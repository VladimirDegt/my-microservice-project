# Terraform RDS Module

Універсальний Terraform модуль для створення RDS баз даних AWS. Підтримує як стандартні RDS інстанси, так і Aurora кластери.

## Функціональність

- **Умовна логіка**: Створює Aurora Cluster або звичайну RDS instance на основі значення `use_aurora`
- **Автоматичне створення ресурсів**:
  - DB Subnet Group
  - Security Group
  - Parameter Group для обраного типу БД
- **Підтримка двигунів**: PostgreSQL та MySQL
- **Гнучка конфігурація**: Мінімальні зміни змінних для багаторазового використання

## Використання

### Стандартна RDS Instance (PostgreSQL)

```hcl
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = false

  # RDS Configuration
  engine                     = "postgres"
  engine_version             = "14.7"
  parameter_group_family_rds = "postgres14"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20

  # Database Configuration
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "your-secure-password"

  # Network Configuration
  vpc_id                     = module.vpc.vpc_id
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false

  # Additional Settings
  multi_az                   = false
  backup_retention_period    = 7
  storage_encrypted          = true
  deletion_protection        = false

  # Custom Parameters
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
    shared_preload_libraries     = "pg_stat_statements"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

### Aurora Cluster (PostgreSQL)

```hcl
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-aurora"
  use_aurora                 = true

  # Aurora Configuration
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  instance_class             = "db.t3.medium"
  aurora_replica_count       = 2

  # Database Configuration
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "your-secure-password"

  # Network Configuration
  vpc_id                     = module.vpc.vpc_id
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false

  # Additional Settings
  backup_retention_period    = 7
  storage_encrypted          = true
  deletion_protection        = false

  # Custom Parameters
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "prod"
    Project     = "myapp"
  }
}
```

### MySQL RDS Instance

```hcl
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-mysql"
  use_aurora                 = false

  # RDS Configuration
  engine                     = "mysql"
  engine_version             = "8.0.35"
  parameter_group_family_rds = "mysql8.0"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20

  # Database Configuration
  db_name                    = "myapp"
  username                   = "admin"
  password                   = "your-secure-password"

  # Network Configuration
  vpc_id                     = module.vpc.vpc_id
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false

  # Additional Settings
  multi_az                   = true
  backup_retention_period    = 7

  # Custom Parameters
  parameters = {
    max_connections = "200"
    slow_query_log  = "1"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}
```

## Змінні

### Обов'язкові змінні

| Змінна               | Опис                         | Тип            |
| -------------------- | ---------------------------- | -------------- |
| `name`               | Назва інстансу або кластера  | `string`       |
| `db_name`            | Назва бази даних             | `string`       |
| `username`           | Ім'я користувача для БД      | `string`       |
| `password`           | Пароль для БД                | `string`       |
| `vpc_id`             | ID VPC                       | `string`       |
| `subnet_private_ids` | Список ID приватних підмереж | `list(string)` |
| `subnet_public_ids`  | Список ID публічних підмереж | `list(string)` |

### Опціональні змінні

| Змінна                    | Опис                                 | Тип           | За замовчуванням      |
| ------------------------- | ------------------------------------ | ------------- | --------------------- |
| `use_aurora`              | Чи використовувати Aurora кластер    | `bool`        | `false`               |
| `engine`                  | Тип двигуна для RDS (postgres/mysql) | `string`      | `"postgres"`          |
| `engine_cluster`          | Тип двигуна для Aurora               | `string`      | `"aurora-postgresql"` |
| `engine_version`          | Версія двигуна для RDS               | `string`      | `"14.7"`              |
| `engine_version_cluster`  | Версія двигуна для Aurora            | `string`      | `"15.3"`              |
| `instance_class`          | Клас інстансу                        | `string`      | `"db.t3.micro"`       |
| `allocated_storage`       | Розмір диску в GB                    | `number`      | `20`                  |
| `aurora_replica_count`    | Кількість reader інстансів           | `number`      | `1`                   |
| `publicly_accessible`     | Публічний доступ                     | `bool`        | `false`               |
| `multi_az`                | Multi-AZ розгортання                 | `bool`        | `false`               |
| `backup_retention_period` | Період збереження backup             | `number`      | `7`                   |
| `storage_encrypted`       | Шифрування зберігання                | `bool`        | `true`                |
| `deletion_protection`     | Захист від видалення                 | `bool`        | `false`               |
| `parameters`              | Параметри БД                         | `map(string)` | `{}`                  |
| `tags`                    | Теги ресурсів                        | `map(string)` | `{}`                  |

## Вихідні дані

### Для стандартної RDS

- `rds_endpoint` - Endpoint для підключення
- `rds_port` - Порт БД
- `rds_identifier` - Ідентифікатор інстансу
- `rds_arn` - ARN інстансу

### Для Aurora

- `aurora_cluster_endpoint` - Endpoint кластера
- `aurora_cluster_reader_endpoint` - Reader endpoint
- `aurora_cluster_identifier` - Ідентифікатор кластера
- `aurora_cluster_arn` - ARN кластера
- `aurora_writer_endpoint` - Writer endpoint
- `aurora_reader_endpoints` - Reader endpoints

### Спільні

- `subnet_group_name` - Назва subnet group
- `security_group_id` - ID security group
- `database_name` - Назва БД
- `username` - Ім'я користувача

## Зміна типу БД

### PostgreSQL → MySQL

```hcl
# Для стандартної RDS
engine                     = "mysql"
engine_version             = "8.0.35"
parameter_group_family_rds = "mysql8.0"

# Для Aurora
engine_cluster             = "aurora-mysql"
engine_version_cluster     = "8.0.mysql_aurora.3.05.1"
parameter_group_family_aurora = "aurora-mysql8.0"
```

### Зміна класу інстансу

```hcl
instance_class = "db.r6g.large"  # Для Aurora
instance_class = "db.t3.large"   # Для стандартної RDS
```

## Примітки

1. **Порти**: Автоматично визначаються (3306 для MySQL, 5432 для PostgreSQL)
2. **Security Group**: Автоматично налаштовується для відповідного порту
3. **Parameter Groups**: Створюються з базовими параметрами та можуть бути кастомізовані
4. **Теги**: Автоматично додаються до всіх ресурсів
5. **Шифрування**: За замовчуванням увімкнено для безпеки

## Приклади параметрів

### PostgreSQL

```hcl
parameters = {
  max_connections              = "200"
  log_min_duration_statement   = "500"
  shared_preload_libraries     = "pg_stat_statements"
  log_statement                = "all"
  work_mem                     = "4MB"
}
```

### MySQL

```hcl
parameters = {
  max_connections = "200"
  slow_query_log  = "1"
  long_query_time = "2"
  innodb_buffer_pool_size = "134217728"
}
```
