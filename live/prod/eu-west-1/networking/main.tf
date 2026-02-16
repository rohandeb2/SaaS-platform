# live/prod/eu-west-1/networking/main.tf

module "vpc_eu_west_1" {
  source = "../../../modules/networking"

  # Explicitly pass the provider alias for Ireland
  providers = {
    aws = aws.eu_west_1
  }

  name_prefix = "acme-prod-euw1"
  vpc_cidr    = "10.1.0.0/16" # Non-overlapping CIDR for Active-Active peering

  tags = {
    Component   = "Networking"
    Environment = "prod"
    Region      = "eu-west-1"
  }
}
