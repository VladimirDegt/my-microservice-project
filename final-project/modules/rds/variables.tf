variable "db_name" {
  description = "Ім'я бази даних"
  type        = string
}

variable "db_user" {
  description = "Користувач бази даних"
  type        = string
}

variable "db_password" {
  description = "Пароль бази даних"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "ID приватних підмереж"
  type        = list(string)
}

variable "db_sg_id" {
  description = "ID security group для RDS"
  type        = string
} 