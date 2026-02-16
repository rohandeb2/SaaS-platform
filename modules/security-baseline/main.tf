# GuardDuty Detectors
resource "aws_guardduty_detector" "primary" {
  provider = aws.us_east_1
  enable   = true
}

resource "aws_guardduty_detector" "secondary" {
  provider = aws.eu_west_1
  enable   = true
}

# Security Hub Enablement
resource "aws_securityhub_account" "primary" {
  provider = aws.us_east_1
}

resource "aws_securityhub_account" "secondary" {
  provider = aws.eu_west_1
}

# Aggregate findings to Primary Region
resource "aws_securityhub_finding_aggregator" "this" {
  provider      = aws.us_east_1
  linking_mode  = "ALL_REGIONS"
  depends_on    = [aws_securityhub_account.primary]
}
