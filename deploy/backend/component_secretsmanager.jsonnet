function(region="eu-west-1")
    {
        apiVersion: "dapr.io/v1alpha1",
        kind: "Component",
        metadata: {
            name: "awssecretmanager",
        },
        spec: {
            type: "secretstores.aws.secretmanager",
            metadata: [
                {
                    name: "region",
                    value: region
                },
            ],
        },
    }