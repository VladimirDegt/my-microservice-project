# Aurora Cluster
resource "aws_rds_cluster" "aurora" {
  count                  = var.use_aurora ? 1 : 0
  cluster_identifier     = "${var.name}-cluster"
  engine                 = var.engine_cluster
  engine_version         = var.engine_version_cluster
  database_name          = var.db_name
  master_username        = var.username
  master_password        = var.password
  port                   = local.db_port
  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  storage_encrypted      = var.storage_encrypted
  deletion_protection    = var.deletion_protection
  backup_retention_period = var.backup_retention_period

  tags = merge(var.tags, {
    Name = "${var.name}-cluster"
  })
}

# Aurora Writer Instance
resource "aws_rds_cluster_instance" "aurora_writer" {
  count               = var.use_aurora ? 1 : 0
  identifier          = "${var.name}-writer"
  cluster_identifier  = aws_rds_cluster.aurora[0].id
  instance_class      = var.instance_class
  engine              = var.engine_cluster
  engine_version      = var.engine_version_cluster
  publicly_accessible = var.publicly_accessible

  tags = merge(var.tags, {
    Name = "${var.name}-writer"
  })
}

# Aurora Reader Instances
resource "aws_rds_cluster_instance" "aurora_readers" {
  count               = var.use_aurora ? var.aurora_replica_count : 0
  identifier          = "${var.name}-reader-${count.index + 1}"
  cluster_identifier  = aws_rds_cluster.aurora[0].id
  instance_class      = var.instance_class
  engine              = var.engine_cluster
  engine_version      = var.engine_version_cluster
  publicly_accessible = var.publicly_accessible

  tags = merge(var.tags, {
    Name = "${var.name}-reader-${count.index + 1}"
  })
}

# Aurora Parameter Group
resource "aws_rds_cluster_parameter_group" "aurora" {
  count       = var.use_aurora ? 1 : 0
  name        = "${var.name}-aurora-params"
  family      = var.parameter_group_family_aurora
  description = "Aurora parameter group for ${var.name}"

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  tags = merge(var.tags, {
    Name = "${var.name}-aurora-params"
  })
}
