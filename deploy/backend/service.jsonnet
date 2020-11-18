local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local service = k.core.v1.service;
local servicePort = k.core.v1.servicePort;

local selectors = {
    name: "backend",
};

function()
    service.new("backend", selectors, [
        servicePort.newNamed(name="http", port="80", targetPort="8080"),
    ])