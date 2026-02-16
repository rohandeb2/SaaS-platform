output "global_cluster_id" {
  value = aws_rds_global_cluster.this.id
}

output "primary_endpoint" {
  value = aws_rds_cluster.primary.endpoint
}

output "secondary_reader_endpoint" {
  value = aws_rds_cluster.secondary.reader_endpoint
}
