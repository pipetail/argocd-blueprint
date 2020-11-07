output "host" {
  value = data.aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(data.aws_eks_cluster.this.certificate_authority.0.data)
}

output "token" {
  value = data.aws_eks_cluster_auth.this.token
}