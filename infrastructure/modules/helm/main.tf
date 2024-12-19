resource "helm_release" "chart" {
  name       = var.release_name
  namespace  = var.namespace
  chart      = var.chart
  repository = var.repository
  version    = var.chart_version

  depends_on = [var.namespace_dependency]

  values = [yamlencode(var.values_map)]
}