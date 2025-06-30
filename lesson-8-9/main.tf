# Підключаємо модуль для S3 та DynamoDB
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

