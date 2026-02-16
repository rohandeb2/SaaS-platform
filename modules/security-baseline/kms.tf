# Primary Multi-Region Key (us-east-1)
resource "aws_kms_key" "primary" {
  provider            = aws.us_east_1
  description         = "SaaS Global Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  multi_region            = true # The critical setting

  policy = data.aws_iam_policy_document.kms_policy.json
}

# Replica Multi-Region Key (eu-west-1)
resource "aws_kms_replica_key" "secondary" {
  provider                = aws.eu_west_1
  description             = "SaaS Global Encryption Key (Replica)"
  primary_key_arn         = aws_kms_key.primary.arn
  deletion_window_in_days = 7
}
