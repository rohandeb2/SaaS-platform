variable "name_prefix" {
  type        = string
  description = "Prefix for security resources (e.g., acme-sec-prod)"
}

variable "tags" {
  type    = map(string)
  default = {}
}

# --- KMS Specifics ---
variable "key_deletion_window" {
  type    = number
  default = 30
  description = "Safety window before KMS key is permanently deleted"
}

# --- Config Specifics ---
variable "config_bucket_name" {
  type        = string
  description = "Central S3 bucket for AWS Config logs"
}

# --- SNS for Alerts ---
variable "security_alerts_email" {
  type        = string
  description = "Email address for GuardDuty and Security Hub findings"
}
