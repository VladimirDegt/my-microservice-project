output "prometheus_release_name" {
  value = helm_release.prometheus.name
}

output "grafana_release_name" {
  value = helm_release.grafana.name
}

output "monitoring_namespace" {
  value = var.namespace
} 