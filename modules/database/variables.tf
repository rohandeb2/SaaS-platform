variable "name_prefix" {
  type        = string
  description = "Prefix for resource naming (e.g., acme-prod-use1)"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where Aurora will be deployed"
}

variable "data_subnet_ids" {
  type        = list(string)
  description = "List of private data subnet IDs"
}

variable "app_security_group_id" {
  type        = string
  description = "The SG ID of the ECS tasks to allow ingress to RDS"
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key for encryption at rest"
}

variable "db_name" {
  type        = string
  default     = "saasdb"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.small" # Graviton instances offer better price/performance
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs for the cluster instances"
}

variable "tags" {
  type        = map(string)
  default     = {}
}
