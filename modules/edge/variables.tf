# modules/edge/variables.tf

variable "name_prefix" {
  type        = string
  description = "Naming prefix for global edge resources"
}

variable "us_alb_dns_name" {
  type        = string
  description = "The DNS name of the Application Load Balancer in US-East-1"
}

variable "us_alb_arn" {
  type        = string
  description = "The ARN of the Application Load Balancer in US-East-1"
}

variable "eu_alb_dns_name" {
  type        = string
  description = "The DNS name of the Application Load Balancer in EU-West-1"
}

variable "tags" {
  type        = map(string)
  description = "Optional tags for resources"
  default     = {}
}

variable "primary_region" {
  type        = string
  description = "The primary AWS region for edge resource management (usually us-east-1)"
}

variable "domain_name" {
  type        = string
  description = "The primary domain name for the SaaS platform (e.g., example.com)"
}

variable "eu_alb_arn" {
  type        = string
  description = "The ARN of the Application Load Balancer in EU-West-1 for Global Accelerator"
}
