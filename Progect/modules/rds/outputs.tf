# Standard RDS Outputs
output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].endpoint
}

output "rds_port" {
  description = "The database port"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].port
}

output "rds_identifier" {
  description = "The RDS instance identifier"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].identifier
}

output "rds_arn" {
  description = "The ARN of the RDS instance"
  value       = var.use_aurora ? null : aws_db_instance.standard[0].arn
}

# Aurora Outputs
output "aurora_cluster_endpoint" {
  description = "The cluster endpoint for the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].endpoint : null
}

output "aurora_cluster_reader_endpoint" {
  description = "The cluster reader endpoint for the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].reader_endpoint : null
}

output "aurora_cluster_identifier" {
  description = "The Aurora cluster identifier"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].cluster_identifier : null
}

output "aurora_cluster_arn" {
  description = "The ARN of the Aurora cluster"
  value       = var.use_aurora ? aws_rds_cluster.aurora[0].arn : null
}

output "aurora_writer_endpoint" {
  description = "The writer instance endpoint"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_writer[0].endpoint : null
}

output "aurora_reader_endpoints" {
  description = "The reader instance endpoints"
  value       = var.use_aurora ? aws_rds_cluster_instance.aurora_readers[*].endpoint : []
}

# Shared Outputs
output "subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.default.name
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.rds.id
}

output "database_name" {
  description = "The name of the database"
  value       = var.db_name
}

output "username" {
  description = "The master username for the database"
  value       = var.username
}
