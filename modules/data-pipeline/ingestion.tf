# Kinesis Stream
resource "aws_kinesis_stream" "ingest" {
  name             = "${var.name_prefix}-stream"
  shard_count      = var.kinesis_shards
  retention_period = 24
  encryption_type  = "KMS"
  kms_key_id       = var.kms_key_arn
}
