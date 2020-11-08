module github.com/pipetail/argocd-blueprint/infrastructure/pulumi

go 1.14

require (
	github.com/pulumi/pulumi-aws/sdk/v3 v3.2.1
	github.com/pulumi/pulumi/sdk/v2 v2.9.2
)

replace github.com/pipetail/argocd-blueprint/infrastructure/pulumi/pkg/vpc v0.0.0 => ../pkg/vpc
