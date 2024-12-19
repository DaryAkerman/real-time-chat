resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace_name
  }
}
output "namespace_name" {
  value = kubernetes_namespace.namespace.metadata[0].name
  description = "The name of the created namespace."
}
