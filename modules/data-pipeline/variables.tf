variable "name_prefix" {
  type        = string
  description = "Prefix to use for naming resources"
}

variable "kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt local resources"
}

variable "destination_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket in eu-west-1 where data will be replicated"
}

variable "destination_kms_key_arn" {
  type        = string
  description = "ARN of the KMS key used to encrypt resources in the destination bucket"
}

variable "kinesis_shards" {
  type        = number
  default     = 1
  description = "Number of Kinesis shards to use for streaming data"
}

