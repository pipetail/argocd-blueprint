data "aws_caller_identity" "this" {}
data "aws_region" "this" {}

resource "aws_kms_key" "this" {
  description = "EKS Secret Encryption Key"
}

module "this" {
  source                        = "terraform-aws-modules/eks/aws"
  version                       = "13.0.0"
  cluster_name                  = var.name
  cluster_version               = var.cluster_version
  subnets                       = var.subnets
  vpc_id                        = var.vpc_id
  worker_ami_name_filter        = var.worker_ami_name_filter
  worker_groups_launch_template = var.worker_groups_launch_template
  cluster_enabled_log_types     = var.cluster_enabled_log_types

  workers_additional_policies = var.workers_additional_policies

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.this.arn
      resources        = ["secrets"]
    }
  ]

  map_roles = var.map_roles
}

data "aws_eks_cluster" "this" {
  name = module.this.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.this.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
  version                = "~> 1.11"
}

resource "aws_iam_openid_connect_provider" "this" {
  url = module.this.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = var.thumbprints
}

resource "aws_security_group_rule" "alb_http_in" {
  security_group_id        = module.this.worker_security_group_id
  type                     = "ingress"
  from_port                = var.traefik_http_port
  to_port                  = var.traefik_http_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}

resource "aws_security_group_rule" "alb_https_in" {
  security_group_id        = module.this.worker_security_group_id
  type                     = "ingress"
  from_port                = var.traefik_https_port
  to_port                  = var.traefik_https_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}

resource "aws_security_group_rule" "alb_admin_in" {
  security_group_id        = module.this.worker_security_group_id
  type                     = "ingress"
  from_port                = var.traefik_admin_port
  to_port                  = var.traefik_admin_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}

