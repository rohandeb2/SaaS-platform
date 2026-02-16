# live/prod/us-east-1/networking/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC in US-East-1"
  value       = module.vpc_us_east_1.vpc_id
}

output "app_subnet_ids" {
  description = "The app subnets in US-East-1"
  value       = module.vpc_us_east_1.app_subnet_ids
}
