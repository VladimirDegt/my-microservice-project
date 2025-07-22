variable "namespace" {
  description = "K8s namespace для моніторингу"
  type        = string
  default     = "monitoring"
}

variable "prometheus_chart_version" {
  description = "Версія чарта Prometheus"
  type        = string
  default     = "56.6.0"
}

variable "grafana_chart_version" {
  description = "Версія чарта Grafana"
  type        = string
  default     = "7.3.9"
} 