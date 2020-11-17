local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local readinessProbe = container.readinessProbe;

local defaultRepository = "docker.pkg.github.com/pipetail/argocd-blueprint/backend";
local defaultTag = "5c6522f56d8120995018b6eef14076a6d67ba8da";

local podAnnotations = {
    "dapr.io/enabled": "true",
    "dapr.io/id": "backend",
    "dapr.io/port": "8080",
};

function(repository=defaultRepository, tag=defaultTag)
    deployment.new(name="backend", containers=[
        container.new(name='backend', image=repository + ":" +tag),
    ])
    + deployment.spec.template.metadata.withAnnotations(podAnnotations)
