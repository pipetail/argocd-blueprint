local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local readinessProbe = container.readinessProbe;

local defaultRepository = "ghcr.io/pipetail/argocd-blueprint/backend";
local defaultTag = "808da12a5e91189f2db72410e2c9afe1e94c4672";

local podAnnotations = {};

function(repository=defaultRepository, tag=defaultTag)
    deployment.new(name="backend", containers=[
        container.new(name='backend', image=repository + ":" +tag),
    ])
    + deployment.spec.template.metadata.withAnnotations(podAnnotations)
    + deployment.spec.template.spec.withServiceAccountName("backend")
    + deployment.spec.template.spec.securityContext.withFsGroup(65534)
