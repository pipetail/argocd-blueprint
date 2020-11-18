local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local readinessProbe = container.readinessProbe;

local defaultRepository = "ghcr.io/pipetail/argocd-blueprint/backend";
local defaultTag = "30cccc12062ba145b1858d7a4c5d15d455386dfe";

local podAnnotations = {};

function(repository=defaultRepository, tag=defaultTag)
    deployment.new(name="backend", containers=[
        container.new(name='backend', image=repository + ":" +tag)
        + container.withPorts([
            containerPort.newNamed(containerPort=8080, name="http"),
        ])

        + readinessProbe.withFailureThreshold(1)
        + readinessProbe.withInitialDelaySeconds(30)
        + readinessProbe.withPeriodSeconds(10)
        + readinessProbe.httpGet.withPort(8080)
        + readinessProbe.httpGet.withPath('/_health/ready'),
    ])
    + deployment.spec.template.metadata.withAnnotations(podAnnotations)
    + deployment.spec.template.spec.withServiceAccountName("backend")
    + deployment.spec.template.spec.securityContext.withFsGroup(65534)
    + deployment.spec.withRevisionHistoryLimit(2)