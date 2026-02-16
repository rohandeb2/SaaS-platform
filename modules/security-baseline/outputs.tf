# KMS Outputs
output "kms_primary_key_arn" {
  description = "The ARN of the primary multi-region key in us-east-1"
  value       = aws_kms_key.primary.arn
}

output "kms_replica_key_arn" {
  description = "The ARN of the replica key in eu-west-1"
  value       = aws_kms_replica_key.secondary.arn
}

output "kms_key_id" {
  description = "The shared UUID for the multi-region key"
  value       = aws_kms_key.primary.key_id
}

# Security Service Outputs
output "guardduty_primary_id" {
  value = aws_guardduty_detector.primary.id
}

output "guardduty_secondary_id" {
  value = aws_guardduty_detector.secondary.id
}

output "security_hub_aggregator_arn" {
  value = aws_securityhub_finding_aggregator.this.id
}

# IAM Role Outputs
output "config_role_arn" {
  value = aws_iam_role.config_role.arn
}

output "auditor_role_arn" {
  value = aws_iam_role.auditor.arn
}
