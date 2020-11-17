local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local readinessProbe = container.readinessProbe;

local defaultRepository = "ghcr.io/pipetail/argocd-blueprint/backend";
local defaultTag = "3749219edd2459e6414447536f547e3308c4e81d";

local podAnnotations = {};

function(repository=defaultRepository, tag=defaultTag)
    deployment.new(name="backend", containers=[
        container.new(name='backend', image=repository + ":" +tag),
    ])
    + deployment.spec.template.metadata.withAnnotations(podAnnotations)
    + deployment.spec.template.spec.withServiceAccountName("backend")
