# Локальні змінні для визначення порту
locals {
  db_port = var.port != null ? var.port : (
    var.engine == "mysql" || var.engine_cluster == "aurora-mysql" ? 3306 : 5432
  )
}

# Subnet group (used by both)
resource "aws_db_subnet_group" "default" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.publicly_accessible ? var.subnet_public_ids : var.subnet_private_ids
  tags       = var.tags
}

# Security group (used by both)
resource "aws_security_group" "rds" {
  name        = "${var.name}-sg"
  description = "Security group for RDS ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.db_port
    to_port     = local.db_port
    protocol    = "tcp"
    cidr_blocks = var.publicly_accessible ? ["0.0.0.0/0"] : ["10.0.0.0/8"]
    description = "Database access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name = "${var.name}-rds-sg"
  })
}
