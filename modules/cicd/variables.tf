# -----------------------------------------------------------
# General Configuration
# -----------------------------------------------------------

variable "name_prefix" {
  type        = string
  description = "Prefix used for naming CI/CD resources"
}

variable "repo" {
  type        = string
  description = "GitHub repository in the format org/repo"
}

variable "cicd_account_id" {
  type        = string
  description = "AWS Account ID where the CI/CD pipeline is deployed"
}

variable "artifact_bucket" {
  type        = string
  description = "Primary S3 bucket for storing build artifacts"
}

variable "artifact_bucket_secondary" {
  type        = string
  description = "Secondary S3 bucket (cross-region) for artifact replication"
}

variable "buildspec_path" {
  type        = string
  default     = "buildspec.yml"
  description = "Path to the buildspec file used by CodeBuild"
}

# -----------------------------------------------------------
# Target Workload Account Configuration
# -----------------------------------------------------------

variable "workload_account_role_arn" {
  type        = string
  description = "IAM Role ARN in the workload account that the pipeline assumes for deployment"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster in the workload account"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the ECS service being deployed"
}

variable "alb_listener_arn" {
  type        = string
  description = "ARN of the ALB listener used for Blue/Green deployments"
}

variable "blue_target_group_name" {
  type        = string
  description = "Name of the Blue target group"
}

variable "green_target_group_name" {
  type        = string
  description = "Name of the Green target group"
}

