resource "aws_cloudwatch_event_bus" "custom" {
  name = "${var.name_prefix}-bus"
}

# SQS with Dead Letter Queue (DLQ)
resource "aws_sqs_queue" "dlq" {
  name = "${var.name_prefix}-main-queue-dlq"
  kms_master_key_id = var.kms_key_arn
}

resource "aws_sqs_queue" "main" {
  name                      = "${var.name_prefix}-main-queue"
  kms_master_key_id         = var.kms_key_arn
  message_retention_seconds = 1209600 # 14 days
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 5
  })
}

# Rule to route events from Bus to SQS
resource "aws_cloudwatch_event_rule" "to_sqs" {
  name           = "${var.name_prefix}-route-to-sqs"
  event_bus_name = aws_cloudwatch_event_bus.custom.name
  event_pattern  = jsonencode({ source = ["my.saas.app"] })
}

resource "aws_cloudwatch_event_target" "sqs" {
  rule           = aws_cloudwatch_event_rule.to_sqs.name
  event_bus_name = aws_cloudwatch_event_bus.custom.name
  arn            = aws_sqs_queue.main.arn
}
