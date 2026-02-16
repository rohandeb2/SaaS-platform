# Create a Security Group for VPC Endpoints in Ireland
resource "aws_security_group" "endpoints" {
  name        = "acme-prod-euw1-vpce-sg" # Updated from use1 to euw1
  description = "Allow HTTPS traffic to VPC Endpoints"
  
  # FIX: Reference module.vpc_eu_west_1 instead of vpc_us_east_1
  vpc_id      = module.vpc_eu_west_1.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"] # Best Practice: Use a different CIDR for secondary region
  }
}

# FIX: Rename the module call to use underscores (Terraform convention)
module "vpc_eu_west_1" {
  source = "../../../../modules/networking"

  name_prefix    = "acme-prod-euw1" # Updated prefix
  vpc_cidr       = "10.1.0.0/16"    # Recommended: Different range than 10.0.0.0/16
  endpoint_sg_id = aws_security_group.endpoints.id

  tags = {
    Component = "Networking"
    Region    = "eu-west-1"
  }
}
