module "vpc_us_east_1" {
  source = "../../../modules/networking"

  # Use the default provider (us-east-1)
  name_prefix = "acme-prod-use1"
  vpc_cidr    = "10.0.0.0/16"

  tags = {
    Component = "Networking"
    Region    = "us-east-1"
  }
}
