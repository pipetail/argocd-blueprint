{
    apiVersion: "traefik.containo.us/v1alpha1",
    kind: "IngressRoute",
    metadata: {
        name: "backend",
    },
    spec: {
        entryPoints: [
            "websecure"
        ],
        routes: [
            {
                match: "Host(`app.dev.eks.rocks`) && PathPrefix(`/api`)",
                kind: "Rule",
                priority: 1,
                services: [
                    {
                        name: "backend",
                        port: 80,
                        scheme: "http",
                    },
                ],
            },
        ],
    },
}
