variable "vpc_cidr" {
  description = "The IPv4 CIDR block for the VPC"
  type        = string
  # No default here to force explicit definition in the live environment
}

variable "name_prefix" {
  description = "Prefix for resource naming (e.g., acme-prod-use1)"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "endpoint_sg_id" { 
  type = string 
}
