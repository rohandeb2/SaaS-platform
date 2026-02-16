variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the mesh components reside"
}

variable "cloud_map_namespace" {
  type        = string
  description = "The name of the Cloud Map private DNS namespace"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
