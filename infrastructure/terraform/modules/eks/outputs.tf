output "worker_security_group_id" {
  value = module.this.worker_security_group_id
}

output "worker_iam_role_name" {
  value = module.this.worker_iam_role_name
}

output "workers_launch_template_arns" {
  value = module.this.workers_launch_template_arns
}

output "oidc_provider_arn" {
  value = module.this.oidc_provider_arn
}

output "cluster_oidc_issuer_url" {
  value = module.this.cluster_oidc_issuer_url
}
