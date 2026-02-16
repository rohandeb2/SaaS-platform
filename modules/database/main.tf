resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-rds-subnet-group"
  subnet_ids = var.data_subnet_ids

  tags = merge(var.tags, { Name = "${var.name_prefix}-rds-subnet-group" })
}

resource "aws_rds_cluster" "this" {
  cluster_identifier      = "${var.name_prefix}-aurora-cluster"
  engine                  = "aurora-postgresql"
  engine_version          = "15.4" # Or latest stable
  availability_zones      = var.availability_zones
  database_name           = var.db_name
  master_username         = "admin_user"
  master_password         = aws_secretsmanager_secret_version.db_pass.secret_string
  backup_retention_period = 7
  preferred_backup_window = "03:00-05:00"
  
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [aws_security_group.rds.id]
  
  storage_encrypted       = true
  kms_key_id              = var.kms_key_arn
  
  # Production safeguards
  deletion_protection     = true
  copy_tags_to_snapshot   = true
  skip_final_snapshot     = false
  final_snapshot_identifier = "${var.name_prefix}-final-snapshot"

  depends_on = [aws_secretsmanager_secret_version.db_pass]i

  enabled_cloudwatch_logs_exports = ["postgresql"]

  lifecycle {
  prevent_destroy = true
}

}

resource "aws_rds_cluster_instance" "this" {
  count              = 2 # 1 Writer, 1 Reader
  identifier         = "${var.name_prefix}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version
  
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible  = false
  
  performance_insights_enabled = true
  performance_insights_kms_key_id = var.kms_key_arn
}
