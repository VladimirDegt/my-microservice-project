variable "cluster_name" {
  description = "Назва EKS кластера"
  type        = string
}

variable "subnet_ids" {
  description = "Список ID підмереж для EKS"
  type        = list(string)
}
