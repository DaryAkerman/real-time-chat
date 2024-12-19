output "release_status" {
  value = helm_release.chart.status
  description = "The status of the Helm release."
}
