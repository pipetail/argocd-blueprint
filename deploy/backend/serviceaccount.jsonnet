local k = import 'github.com/jsonnet-libs/k8s-alpha/1.18/main.libsonnet';
local serviceAccount = k.core.v1.serviceAccount;

local annotations = {
    "eks.amazonaws.com/role-arn": "arn:aws:iam::454676813835:role/eks_sa_backend_backend_eu-west-1"
};

function()
    serviceAccount.new("backend")
    + serviceAccount.metadata.withAnnotations(annotations)