variable "name" {
  description = "Назва інстансу або кластера"
  type        = string
}

variable "engine" {
  description = "Тип двигуна для стандартної RDS (postgres або mysql)"
  type        = string
  default     = "postgres"
  validation {
    condition     = contains(["postgres", "mysql"], var.engine)
    error_message = "Engine повинен бути 'postgres' або 'mysql'."
  }
}

variable "engine_cluster" {
  description = "Тип двигуна для Aurora кластера"
  type        = string
  default     = "aurora-postgresql"
  validation {
    condition     = contains(["aurora-postgresql", "aurora-mysql"], var.engine_cluster)
    error_message = "Engine cluster повинен бути 'aurora-postgresql' або 'aurora-mysql'."
  }
}

variable "aurora_replica_count" {
  description = "Кількість reader інстансів для Aurora"
  type        = number
  default     = 1
  validation {
    condition     = var.aurora_replica_count >= 0 && var.aurora_replica_count <= 15
    error_message = "Aurora replica count повинен бути між 0 та 15."
  }
}

variable "aurora_instance_count" {
  description = "Загальна кількість інстансів для Aurora (deprecated, використовуйте aurora_replica_count)"
  type        = number
  default     = 2
}

variable "engine_version" {
  description = "Версія двигуна для стандартної RDS"
  type        = string
  default     = "14.7"
}

variable "engine_version_cluster" {
  description = "Версія двигуна для Aurora кластера"
  type        = string
  default     = "15.3"
}

variable "instance_class" {
  description = "Клас інстансу для БД"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Розмір диску в GB (тільки для стандартної RDS)"
  type        = number
  default     = 20
  validation {
    condition     = var.allocated_storage >= 20 && var.allocated_storage <= 65536
    error_message = "Allocated storage повинен бути між 20 та 65536 GB."
  }
}

variable "db_name" {
  description = "Назва бази даних"
  type        = string
}

variable "username" {
  description = "Ім'я користувача для БД"
  type        = string
}

variable "password" {
  description = "Пароль для БД"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID VPC"
  type        = string
}

variable "subnet_private_ids" {
  description = "Список ID приватних підмереж"
  type        = list(string)
}

variable "subnet_public_ids" {
  description = "Список ID публічних підмереж"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Чи доступна БД з публічної мережі"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Чи використовувати Multi-AZ розгортання (тільки для стандартної RDS)"
  type        = bool
  default     = false
}

variable "parameters" {
  description = "Параметри для parameter group"
  type        = map(string)
  default     = {}
}

variable "use_aurora" {
  description = "Чи використовувати Aurora кластер замість стандартної RDS"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Період збереження backup в днях"
  type        = number
  default     = 7
  validation {
    condition     = var.backup_retention_period >= 0 && var.backup_retention_period <= 35
    error_message = "Backup retention period повинен бути між 0 та 35 днів."
  }
}

variable "tags" {
  description = "Теги для ресурсів"
  type        = map(string)
  default     = {}
}

variable "parameter_group_family_aurora" {
  description = "Сімейство parameter group для Aurora"
  type        = string
  default     = "aurora-postgresql15"
}

variable "parameter_group_family_rds" {
  description = "Сімейство parameter group для стандартної RDS"
  type        = string
  default     = "postgres15"
}

variable "port" {
  description = "Порт для БД (автоматично визначається залежно від двигуна)"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Чи шифрувати зберігання даних"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Чи захищати від видалення"
  type        = bool
  default     = false
}
