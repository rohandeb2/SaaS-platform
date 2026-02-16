# Generate a secure random password
resource "random_password" "master" {
  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# The Secret must be created in the Primary Region
resource "aws_secretsmanager_secret" "db_credentials" {
  provider    = aws.primary
  name        = "${var.global_identifier}-db-credentials"
  description = "Global Aurora Postgres credentials"
  kms_key_id  = var.primary_kms_key_arn

  # Production-grade: Replicate the secret to the secondary region
  replica {
    region     = "eu-west-1"
    kms_key_id = var.secondary_kms_key_arn
  }

  tags = {
    Name = "${var.global_identifier}-db-secret"
  }
}

resource "aws_secretsmanager_secret_version" "db_pass" {
  provider      = aws.primary
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = random_password.master.result
}
