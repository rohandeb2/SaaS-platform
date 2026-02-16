# Lambda Function for Data Transformation/Processing
resource "aws_lambda_function" "consumer" {
  filename      = "lambda_function_payload.zip" # Local path to your deployment package
  function_name = "${var.name_prefix}-data-transformer"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "index.handler"
  runtime       = "python3.11"
  timeout       = 60
  memory_size   = 128

  # Enable X-Ray Tracing
  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      ENVIRONMENT = "prod"
      S3_LAKE_ID  = aws_s3_bucket.lake.id
    }
  }
}

# Lambda Permission for Firehose to Invoke
resource "aws_lambda_permission" "allow_firehose" {
  statement_id  = "AllowExecutionFromFirehose"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.consumer.function_name
  principal     = "firehose.amazonaws.com"
  source_arn    = aws_kinesis_firehose_delivery_stream.to_s3.arn
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "${var.name_prefix}-lambda-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Standard Lambda Logging and X-Ray permissions
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_xray" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}
