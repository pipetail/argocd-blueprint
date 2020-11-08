package vpc

import (
	"github.com/pulumi/pulumi-aws/sdk/v3/go/aws/ec2"
	"github.com/pulumi/pulumi/sdk/v2/go/pulumi"
)

type Vpc struct {
	*ec2.Vpc
}

// Subnet is wrapper struct for Subnet
type Subnet struct {
	*ec2.Subnet
}

// New creates a new VPC with some sane details
func New(ctx *pulumi.Context, name string, vpcCIDR string) (Vpc, error) {
	var output Vpc

	vpc, err := ec2.NewVpc(ctx, "main", &ec2.VpcArgs{
		CidrBlock: pulumi.String("10.0.0.0/16"),
	})

	if err != nil {
		return output, err
	}

	output = Vpc{vpc}
	return output, nil
}

// AddSubnet adds Subnet to the VPC
func (v Vpc) AddSubnet(ctx *pulumi.Context, name string, subnetCIDR string) (Subnet, error) {
	var output Subnet

	subnet, err := ec2.NewSubnet(
		ctx,
		name,
		&ec2.SubnetArgs{
			VpcId:     v.ID(),
			CidrBlock: pulumi.String(subnetCIDR),
			Tags:      pulumi.StringMap{},
		},
		pulumi.Parent(v),
	)

	if err != nil {
		return output, err
	}

	output = Subnet{subnet}

	return output, nil
}

// WithInternetGateway connects subnet to the Internet Gateway
// Subnet connected to Internet Gateway is considered as public
func (s Subnet) WithInternetGateway() {

}
