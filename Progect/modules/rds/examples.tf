# Приклади використання модуля RDS
# Цей файл містить різні конфігурації для тестування

# Приклад 1: Стандартна PostgreSQL RDS
module "postgres_rds" {
  source = "./modules/rds"

  name                       = "postgres-example"
  use_aurora                 = false
  
  # RDS Configuration
  engine                     = "postgres"
  engine_version             = "14.7"
  parameter_group_family_rds = "postgres14"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  
  # Database Configuration
  db_name                    = "example_db"
  username                   = "postgres"
  password                   = "secure_password_123"
  
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
    max_connections              = "100"
    log_min_duration_statement   = "1000"
    shared_preload_libraries     = "pg_stat_statements"
  }

  tags = {
    Environment = "dev"
    Project     = "example"
    Type        = "postgres-rds"
  }
}

# Приклад 2: Aurora PostgreSQL Cluster
module "aurora_postgres" {
  source = "./modules/rds"

  name                       = "aurora-postgres-example"
  use_aurora                 = true
  
  # Aurora Configuration
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.3"
  parameter_group_family_aurora = "aurora-postgresql15"
  instance_class             = "db.t3.medium"
  aurora_replica_count       = 2
  
  # Database Configuration
  db_name                    = "aurora_example"
  username                   = "postgres"
  password                   = "secure_password_123"
  
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
    Project     = "example"
    Type        = "aurora-postgres"
  }
}

# Приклад 3: MySQL RDS Instance
module "mysql_rds" {
  source = "./modules/rds"

  name                       = "mysql-example"
  use_aurora                 = false
  
  # RDS Configuration
  engine                     = "mysql"
  engine_version             = "8.0.35"
  parameter_group_family_rds = "mysql8.0"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  
  # Database Configuration
  db_name                    = "mysql_example"
  username                   = "admin"
  password                   = "secure_password_123"
  
  # Network Configuration
  vpc_id                     = module.vpc.vpc_id
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = false
  
  # Additional Settings
  multi_az                   = true
  backup_retention_period    = 7
  storage_encrypted          = true
  deletion_protection        = false
  
  # Custom Parameters
  parameters = {
    max_connections = "150"
    slow_query_log  = "1"
    long_query_time = "2"
  }

  tags = {
    Environment = "dev"
    Project     = "example"
    Type        = "mysql-rds"
  }
}

# Приклад 4: Aurora MySQL Cluster
module "aurora_mysql" {
  source = "./modules/rds"

  name                       = "aurora-mysql-example"
  use_aurora                 = true
  
  # Aurora Configuration
  engine_cluster             = "aurora-mysql"
  engine_version_cluster     = "8.0.mysql_aurora.3.05.1"
  parameter_group_family_aurora = "aurora-mysql8.0"
  instance_class             = "db.t3.medium"
  aurora_replica_count       = 1
  
  # Database Configuration
  db_name                    = "aurora_mysql_example"
  username                   = "admin"
  password                   = "secure_password_123"
  
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
    max_connections = "200"
    slow_query_log  = "1"
  }

  tags = {
    Environment = "prod"
    Project     = "example"
    Type        = "aurora-mysql"
  }
} 