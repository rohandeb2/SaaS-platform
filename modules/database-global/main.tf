# 1. The Global Cluster Shell (Non-regional)
resource "aws_rds_global_cluster" "this" {
  global_cluster_identifier = "${var.global_identifier}-global"
  engine                    = "aurora-postgresql"
  engine_version            = "15.4"
  database_name             = var.db_name
  storage_encrypted         = true
}

# 2. Primary Cluster (us-east-1)
resource "aws_rds_cluster" "primary" {
  provider                  = aws.primary
  cluster_identifier        = "${var.global_identifier}-primary"
  global_cluster_identifier = aws_rds_global_cluster.this.id
  
  engine                  = aws_rds_global_cluster.this.engine
  engine_version          = aws_rds_global_cluster.this.engine_version
  db_subnet_group_name    = var.primary_subnet_group
  vpc_security_group_ids  = [var.primary_security_group_id]
  
  master_username         = var.master_username
  master_password         = var.master_password
  
  backup_retention_period = 7
  storage_encrypted       = true
  kms_key_id              = var.primary_kms_key_arn

  depends_on = [aws_rds_global_cluster.this]
}

# 3. Secondary Cluster (eu-west-1)
resource "aws_rds_cluster" "secondary" {
  provider                  = aws.secondary
  cluster_identifier        = "${var.global_identifier}-secondary"
  global_cluster_identifier = aws_rds_global_cluster.this.id
  
  engine                  = aws_rds_global_cluster.this.engine
  engine_version          = aws_rds_global_cluster.this.engine_version
  db_subnet_group_name    = var.secondary_subnet_group
  vpc_security_group_ids  = [var.secondary_security_group_id]
  
  # Secondary region uses its own regional KMS key
  storage_encrypted       = true
  kms_key_id              = var.secondary_kms_key_arn

  depends_on = [
    aws_rds_global_cluster.this,
    aws_rds_cluster.primary
  ]
}
