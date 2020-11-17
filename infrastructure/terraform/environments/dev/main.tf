data "aws_availability_zones" "this" {}
data "aws_caller_identity" "this" {}

module "vpc" {
  source          = "../../modules/vpc"
  name            = "dev"
  cidr            = "10.100.0.0/16"
  azs             = data.aws_availability_zones.this.names
  private_subnets = ["10.100.0.0/23", "10.100.2.0/23", "10.100.4.0/23"]
  public_subnets  = ["10.100.6.0/23", "10.100.8.0/23", "10.100.10.0/23"]
  project_name    = "argocd_blueprint"
  env             = "dev"
}

module "alb" {
  source       = "../../modules/alb"
  env          = "dev"
  project_name = "argocd_blueprint"
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.public_subnets
  http_allow_cidrs = [
    "0.0.0.0/0",
  ]
  https_allow_cidrs = [
    "0.0.0.0/0",
  ]
  certificate_arn = "arn:aws:acm:${data.aws_availability_zones.this.id}:${data.aws_caller_identity.this.account_id}:certificate/3c175e6e-b032-46b7-84a9-db7ba16fd972"
}

module "eks" {
  source                 = "../../modules/eks"
  name                   = "argocd_blueprint_dev"
  cluster_version        = "1.18"
  subnets                = module.vpc.private_subnets
  vpc_id                 = module.vpc.vpc_id
  worker_ami_name_filter = "amazon-eks-node-1.18-v20201007"
  alb_security_group_id  = module.alb.security_group_id
  thumbprints = [
    "711cdb21382ca95773ece1d553c4b1981412e4f8",
  ]

  map_roles = []

  worker_groups_launch_template = [
    {
      name                    = "dev_spot"
      instance_type           = "t3.medium"
      override_instance_types = ["t3.medium", "t3a.medium"]
      asg_max_size            = 2
      asg_min_size            = 2
      asg_desired_capacity    = 2
      autoscaling_enabled     = true
      termination_policies    = ["OldestInstance"]
      subnets                 = slice(module.vpc.private_subnets, 0, 1)
      enable_monitoring       = false
      tags                    = concat(local.autoscaling_tags)
      kubelet_extra_args      = "--kube-reserved=memory=0.3Gi,ephemeral-storage=1Gi --system-reserved=memory=0.2Gi,ephemeral-storage=1Gi --eviction-hard=memory.available<200Mi,nodefs.available<10%"
    }
  ]
}

resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.this.zone_id
  name    = "argocd.${data.aws_route53_zone.this.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [
    module.alb.dns_name,
  ]
}

