locals {
  eks_cluster_name = [
    var.project_name,
    var.env
  ]
}
