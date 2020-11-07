import * as awsx from "@pulumi/awsx";
import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as k8s from "@pulumi/kubernetes";
import * as http from "http";
import * as https from "https";
import * as HttpsProxyAgent from "https-proxy-agent";
import * as url from "url";

// VPC with single NAT gateway
const vpc = new awsx.ec2.Vpc("development", {
    cidrBlock: "10.0.0.0/16",
    numberOfAvailabilityZones: 3,
    subnets: [
        {type: "private"},
        {type: "public"},
    ],
    numberOfNatGateways: 1,
});

// EKS role for control plane
const eksControlPlaneRole = new aws.iam.Role("eks-control-plane", {
    assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
            {
                Action: "sts:AssumeRole",
                Effect: "Allow",
                Principal: {
                    Service: "eks.amazonaws.com",
                },
            }
        ],
    })
});

new aws.iam.RolePolicyAttachment("eks-control-plane-cluster-policy", {
    role: eksControlPlaneRole.name,
    policyArn: "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
});

new aws.iam.RolePolicyAttachment("eks-control-plane-service-policy", {
    role: eksControlPlaneRole.name,
    policyArn: "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
});

// EKS role for worker
const eksWorkersRole = new aws.iam.Role("eks-worker", {
    assumeRolePolicy: JSON.stringify({
        Version: "2012-10-17",
        Statement: [
            {
                Action: "sts:AssumeRole",
                Effect: "Allow",
                Principal: {
                    Service: "ec2.amazonaws.com",
                },
            }
        ],
    })
});

new aws.iam.RolePolicyAttachment("eks-worker-node-policy", {
    role: eksWorkersRole.name,
    policyArn: "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
});

new aws.iam.RolePolicyAttachment("eks-worker-cni-policy", {
    role: eksWorkersRole.name,
    policyArn: "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
});

new aws.iam.RolePolicyAttachment("eks-worker-ecr-policy", {
    role: eksWorkersRole.name,
    policyArn: "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
});

// security group for EKS workers
const eksWorkersSecurityGroup = new aws.ec2.SecurityGroup("eks-workers", {
    name: "eks-workers",
    vpcId: vpc.id,
    description: "Security Group for EKS workers"
});

new aws.ec2.SecurityGroupRule("eks-workers-egress", {
    securityGroupId: eksWorkersSecurityGroup.id,
    type: "egress",
    fromPort: 0,
    toPort: 0,
    protocol: "all",
    cidrBlocks: [
        "0.0.0.0/0",
    ],
});

// eks cluster
const eksControlPlane = new aws.eks.Cluster("development", {
    name: "development",
    roleArn: eksControlPlaneRole.arn,
    vpcConfig: {
        subnetIds: vpc.privateSubnetIds,
        endpointPrivateAccess: true,
        endpointPublicAccess: true,
        publicAccessCidrs: [
            "0.0.0.0/0",
        ],
        securityGroupIds: [
            eksWorkersSecurityGroup.id,
        ]
    },
    version: "1.18",
});

// managed node group
const mainEksNodeGroup = new aws.eks.NodeGroup("main", {
    clusterName: eksControlPlane.name,
    nodeRoleArn: eksWorkersRole.arn,
    subnetIds: vpc.privateSubnetIds,
    scalingConfig: {
        desiredSize: 2,
        minSize: 1,
        maxSize: 10,
    },
    instanceTypes: "t3.medium",
});

// alb
// eksControlPlane.vpcConfig.clusterSecurityGroupId

// kubernetes stuff
const eksEndpoint = eksControlPlane.endpoint.apply(async (clusterEndpoint) => {
    if (!pulumi.runtime.isDryRun()) {
        // For up to 300 seconds, try to contact the API cluster healthz
        // endpoint, and verify that it is reachable.
        const healthz = `${clusterEndpoint}/healthz`;
        const agent = new https.Agent({
            maxCachedSessions: 0,
        });
        const maxRetries = 60;
        const reqTimeoutMilliseconds = 1000; // HTTPS request timeout
        const timeoutMilliseconds = 5000; // Retry timeout
        for (let i = 0; i < maxRetries; i++) {
            try {
                await new Promise((resolve, reject) => {
                    const options = {
                        ...url.parse(healthz),
                        rejectUnauthorized: false, // EKS API server uses self-signed cert
                        agent: agent,
                        timeout: reqTimeoutMilliseconds,
                    };
                    const req = https
                        .request(options, res => {
                            res.statusCode === 200 ? resolve() : reject(); // Verify healthz returns 200
                        });
                    req.on("timeout", reject);
                    req.on("error", reject);
                    req.end();
                });
                pulumi.log.info(`Cluster is ready`, eksControlPlane, undefined, true);
                break;
            } catch (e) {
                const retrySecondsLeft = (maxRetries - i) * timeoutMilliseconds / 1000;
                pulumi.log.info(`Waiting up to (${retrySecondsLeft}) more seconds for cluster readiness...`, eksControlPlane, undefined, true);
            }
            await new Promise(resolve => setTimeout(resolve, timeoutMilliseconds));
        }
    }
    return clusterEndpoint;
});

// exports
export const vpcId = vpc.id;
export const endpoint = eksEndpoint;




