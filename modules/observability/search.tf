resource "aws_opensearch_domain" "this" {
  domain_name    = "${var.name_prefix}-logs"
  engine_version = "OpenSearch_2.11"

  cluster_config {
    instance_type            = "t3.small.search"
    instance_count           = 2
    dedicated_master_enabled = false # Set to true for large production clusters
    zone_awareness_enabled   = true
    
    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 20
    volume_type = "gp3"
  }

  encrypt_at_rest {
    enabled    = true
    kms_key_id = var.kms_key_arn
  }

  node_to_node_encryption {
    enabled = true
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
}
