resource "aws_dynamodb_table" "this" {
  name             = var.table_name
  billing_mode     = "PAY_PER_REQUEST" # On-demand for SaaS scaling
  hash_key         = var.hash_key
  range_key        = var.range_key

  # Production Security & Resilience
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES" # Required for Global Tables
  
  point_in_time_recovery {
    enabled = true
  }

  lifecycle {
  prevent_destroy = true
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.primary_kms_key_arn
  }

  # Attribute Definitions
  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  # Primary Region Replica (us-east-1)
  replica {
    region_name = "us-east-1"
    kms_key_arn = var.primary_kms_key_arn
    point_in_time_recovery = true
  }

  # Secondary Region Replica (eu-west-1)
  replica {
    region_name = "eu-west-1"
    kms_key_arn = var.secondary_kms_key_arn
    point_in_time_recovery = true
  }

  tags = merge(var.tags, { Name = var.table_name })
}
