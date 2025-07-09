module "s3_backend" {
  source      = "./modules/s3-backend"                # Шлях до модуля
  bucket_name = "terraform-state-bucket-Volodymyr"       # Ім'я S3-бакета
  table_name  = "terraform-locks"                     # Ім'я DynamoDB
}

module "vpc" {
  source              = "./modules/vpc"           # Шлях до модуля VPC
  vpc_cidr_block      = "10.0.0.0/16"             # CIDR блок для VPC
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]        # Публічні підмережі
  private_subnets     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]         # Приватні підмережі
  availability_zones  = ["us-west-2a", "us-west-2b", "us-west-2c"]            # Зони доступності
  vpc_name            = "lesson-5-vpc"            # Ім'я VPC
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

module "jenkins" {
  source       = "./modules/jenkins"
  cluster_name = module.eks.eks_cluster_name

  providers = {
    helm = helm
  }
}

module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"
}

module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = false
  aurora_instance_count      = 2

  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"

  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}

# Приклад Aurora кластера (закоментований)
# module "rds_aurora" {
#   source = "./modules/rds"
#
#   name                       = "myapp-aurora"
#   use_aurora                 = true
#   aurora_replica_count       = 2
#
#   # Aurora Configuration
#   engine_cluster             = "aurora-postgresql"
#   engine_version_cluster     = "15.3"
#   parameter_group_family_aurora = "aurora-postgresql15"
#   instance_class             = "db.t3.medium"
#
#   # Common
#   db_name                    = "myapp"
#   username                   = "postgres"
#   password                   = "admin123AWS23"
#   subnet_private_ids         = module.vpc.private_subnets
#   subnet_public_ids          = module.vpc.public_subnets
#   publicly_accessible        = false
#   vpc_id                     = module.vpc.vpc_id
#   backup_retention_period    = 7
#   parameters = {
#     max_connections              = "200"
#     log_min_duration_statement   = "500"
#   }
#
#   tags = {
#     Environment = "prod"
#     Project     = "myapp"
#   }
# }

