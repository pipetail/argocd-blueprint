module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name               = var.name
  cidr               = var.cidr
  azs                = var.azs
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  enable_s3_endpoint = var.enable_s3_endpoint

  enable_nat_gateway   = true
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${join("_", local.eks_cluster_name)}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${join("_", local.eks_cluster_name)}" = "shared"
    "kubernetes.io/role/elb"                                     = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${join("_", local.eks_cluster_name)}" = "shared"
    "kubernetes.io/role/internal-elb"                            = "1"
  }
}
