variable "name_prefix" {
  type        = string
  description = "Prefix for resource naming"
}

variable "region" {
  type        = string
  description = "AWS region for logging and X-Ray"
}

variable "vpc_id" {
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Subnets for the ALB"
}

variable "app_subnet_ids" {
  type        = list(string)
  description = "Subnets for the Fargate Tasks"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "container_image" {
  type        = string
  description = "ECR Image URI"
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "min_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 10
}

variable "app_mesh_node_arn" {
  type        = string
  description = "The ARN of the App Mesh Virtual Node for this service"
}
