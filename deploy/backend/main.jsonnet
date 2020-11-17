local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local deployment = k.apps.v1.deployment;
local container = k.core.v1.container;
local containerPort = k.core.v1.containerPort;
local readinessProbe = container.readinessProbe;

function(repository="", tag="")
    {}