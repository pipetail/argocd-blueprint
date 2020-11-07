module "this" {
  source                        = "terraform-aws-modules/eks/aws"
  cluster_name                  = var.cluster_name
  cluster_version               = var.cluster_version
  subnets                       = var.subnets
  vpc_id                        = var.vpc_id
  worker_groups_launch_template = var.worker_groups_launch_template
  workers_additional_policies   = var.workers_additional_policies
  map_users                     = var.map_users
  map_roles                     = var.map_roles
  wait_for_cluster_cmd          = var.wait_for_cluster_cmd
  wait_for_cluster_interpreter  = var.wait_for_cluster_interpreter
}

data "aws_eks_cluster" "this" {
  name = module.this.cluster_id
}

data "aws_eks_cluster_auth" "this" {
  name = module.this.cluster_id
}

// needed for aws-auth CM
provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
  version                = "~> 1.9"
}

resource "aws_iam_openid_connect_provider" "eks" {
  url = module.this.cluster_oidc_issuer_url

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = var.thumbprints
}