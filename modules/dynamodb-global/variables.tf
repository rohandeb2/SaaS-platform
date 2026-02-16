variable "table_name" {
  type        = string
  description = "The name of the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "The partition key"
}

variable "range_key" {
  type        = string
  default     = null
  description = "The sort key (optional)"
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  description = "List of nested attribute definitions (name and type)"
}

variable "primary_kms_key_arn" {
  type        = string
  description = "KMS ARN for us-east-1"
}

variable "secondary_kms_key_arn" {
  type        = string
  description = "KMS ARN for eu-west-1"
}

variable "tags" {
  type    = map(string)
  default = {}
}
