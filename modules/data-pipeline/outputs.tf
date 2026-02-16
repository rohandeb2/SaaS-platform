output "event_bus_arn" {
  value       = aws_cloudwatch_event_bus.custom.arn
  description = "The ARN of the custom CloudWatch EventBridge event bus"
}

output "kinesis_stream_name" {
  value       = aws_kinesis_stream.ingest.name
  description = "The name of the Kinesis stream used for data ingestion"
}

output "data_lake_bucket_id" {
  value       = aws_s3_bucket.lake.id
  description = "The ID of the S3 bucket used as the data lake"
}

