package main

import (
	"github.com/pipetail/argocd-blueprint/infrastructure/pulumi/pkg/vpc"
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {

		// create the main VPC with some sane defaults
		vpc, err := vpc.New(ctx, "main", "10.0.0.0/16")
		if err != nil {
			return err
		}

		_, err = vpc.AddSubnet(ctx, "private1", "10.0.0.0/24")
		if err != nil {
			return err
		}

		// all good
		return nil
	})
}
