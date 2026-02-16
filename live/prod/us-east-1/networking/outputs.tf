# live/prod/eu-west-1/networking/outputs.tf

output "eu_vpc_id" {
  description = "The ID of the VPC in Ireland"
  value       = module.vpc_eu_west_1.vpc_id
}

output "eu_app_subnets" {
  description = "The application subnets in Ireland"
  value       = module.vpc_eu_west_1.app_subnet_ids
}
