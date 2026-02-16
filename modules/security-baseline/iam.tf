# Least-Privilege Auditor Role
resource "aws_iam_role" "auditor" {
  name = "SaaS-Security-Auditor"
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy_attachment" "read_only" {
  role       = aws_iam_role.auditor.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Role for AWS Config
# This role only needs to be defined once globally.
resource "aws_iam_role" "config_role" {
  provider = aws.us_east_1 # Explicitly pin to one provider
  name     = "${var.name_prefix}-aws-config-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "config.amazonaws.com" }
    }]
  })
}


