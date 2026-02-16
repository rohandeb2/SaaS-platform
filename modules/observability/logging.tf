# Central Log Group for Application
resource "aws_cloudwatch_log_group" "app" {
  name              = "/saas/prod/application"
  retention_in_days = 30
  kms_key_id        = var.kms_key_arn
}

# SNS Topic for Critical Alerts
resource "aws_sns_topic" "alerts" {
  name              = "${var.name_prefix}-alerts"
  kms_master_key_id = "alias/aws/sns" # Using AWS managed key for simplicity
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}
