variable "name_prefix" {
  type        = string
  description = "Prefix to use for naming resources"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt resources"
}

variable "alert_email" {
  type        = string
  description = "Email address to send alerts or notifications"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to apply to all resources (optional)"
}

