locals {
  cluster_oidc_issuer = replace(var.cluster_oidc_issuer_url, "https://", "")
}
