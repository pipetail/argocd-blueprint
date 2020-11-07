resource "kubernetes_manifest" "this" {
  provider = kubernetes-alpha

  manifest = {
    "apiVersion" = "v1"
    "kind"       = "ConfigMap"
    "metadata" = {
      "name"      = "test-config"
      "namespace" = var.namespace
    }
    "data" = {
      "foo" = "bar"
    }
  }
}
