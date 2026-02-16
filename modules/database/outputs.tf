output "cluster_endpoint" {
  value       = aws_rds_cluster.this.endpoint
  description = "The writer endpoint for the cluster"
}

output "reader_endpoint" {
  value       = aws_rds_cluster.this.reader_endpoint
  description = "The read-only endpoint for the cluster"
}

output "cluster_arn" {
  value       = aws_rds_cluster.this.arn
}

output "database_name" {
  value = aws_rds_cluster.this.database_name
}

output "secrets_manager_arn" {
  value       = aws_secretsmanager_secret.db_credentials.arn
  description = "ARN of the secret containing DB credentials"
}
