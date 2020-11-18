local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local readinessProbe = container.readinessProbe;

local defaultRepository = "ghcr.io/pipetail/argocd-blueprint/backend";
local defaultTag = "8411d5e6efc3d1146ba510b42d7479511e25d8fa";

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