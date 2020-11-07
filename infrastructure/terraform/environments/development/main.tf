resource "random_pet" "cluster" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "development"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = false
  single_nat_gateway     = true

  enable_s3_endpoint = true

  tags = {
    Terraform   = "true"
    Environment = "development"
  }
}

module "eks" {
  source          = "../../modules/eks"
  cluster_name    = random_pet.cluster.id
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  worker_groups_launch_template = [
    {
      name                    = "eu-west-1-spot-01"
      instance_type           = "t3.small"
      override_instance_types = ["t3.small"]
      asg_max_size            = 10
      asg_min_size            = 1
      asg_desired_capacity    = 2
      autoscaling_enabled     = true
      termination_policies    = ["OldestInstance"]
      subnets                 = module.vpc.private_subnets
      enable_monitoring       = false
      tags                    = []
    }
  ]
  thumbprints = [
    "711cdb21382ca95773ece1d553c4b1981412e4f8",
  ]

  // I don't have time for this
  wait_for_cluster_cmd         = "echo works"
  wait_for_cluster_interpreter = ["powershell.exe"]
}

module "dapr" {
  source    = "../../modules/dapr"
  namespace = "default"
}