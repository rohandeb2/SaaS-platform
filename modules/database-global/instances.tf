# Primary Instances (us-east-1)
resource "aws_rds_cluster_instance" "primary" {
  provider           = aws.primary
  count              = var.primary_instance_count
  identifier         = "${var.global_identifier}-primary-${count.index}"
  cluster_identifier = aws_rds_cluster.primary.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.primary.engine
  engine_version     = aws_rds_cluster.primary.engine_version
}

# Secondary Instances (eu-west-1)
resource "aws_rds_cluster_instance" "secondary" {
  provider           = aws.secondary
  count              = var.secondary_instance_count
  identifier         = "${var.global_identifier}-secondary-${count.index}"
  cluster_identifier = aws_rds_cluster.secondary.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.secondary.engine
  engine_version     = aws_rds_cluster.secondary.engine_version
}
