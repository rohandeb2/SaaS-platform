# Firehose Role
resource "aws_iam_role" "firehose" {
  name = "${var.name_prefix}-firehose-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "firehose.amazonaws.com" } }]
  })
}

# S3 Replication Role
resource "aws_iam_role" "replication" {
  name = "${var.name_prefix}-s3-replication-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "s3.amazonaws.com" } }]
  })
}
