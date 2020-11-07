provider "aws" {
  region  = "eu-west-1"
  version = "~> 3.0"
}

provider "kubernetes-alpha" {
  host                   = module.eks.host
  cluster_ca_certificate = module.eks.cluster_ca_certificate
  token                  = module.eks.token
}
