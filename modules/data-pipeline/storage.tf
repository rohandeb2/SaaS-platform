# S3 Data Lake with Versioning
resource "aws_s3_bucket" "lake" {
  bucket = "${var.name_prefix}-data-lake"
}

resource "aws_s3_bucket_versioning" "lake" {
  bucket = aws_s3_bucket.lake.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "lake" {
  bucket = aws_s3_bucket.lake.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
  lifecycle {
  prevent_destroy = true
}
}

# Firehose Delivery Stream
resource "aws_kinesis_firehose_delivery_stream" "to_s3" {
  name        = "${var.name_prefix}-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose.arn
    bucket_arn = aws_s3_bucket.lake.arn
    
    processing_configuration {
      enabled = "true"
      processors {
        type = "Lambda"
        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.consumer.arn}:$LATEST"
        }
      }
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "lake_replication" {
  # Must use the provider for the source region
  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.lake.id

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = var.destination_bucket_arn
      storage_class = "STANDARD"
      # Ensure encryption is maintained cross-region
      encryption_configuration {
        replica_kms_key_id = var.destination_kms_key_arn
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "lake" {
  bucket = aws_s3_bucket.lake.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
