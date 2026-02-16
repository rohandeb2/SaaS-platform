# Create a Security Group for VPC Endpoints
resource "aws_security_group" "endpoints" {
  name        = "acme-prod-use1-vpce-sg"
  description = "Allow HTTPS traffic to VPC Endpoints"
  vpc_id      = module.vpc_us_east_1.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Should match your vpc_cidr
  }
}

module "vpc_us_east_1" {
  source = "../../../../modules/networking"

  name_prefix    = "acme-prod-use1"
  vpc_cidr       = "10.0.0.0/16"
  endpoint_sg_id = aws_security_group.endpoints.id # Pass the new SG ID here

  tags = {
    Component = "Networking"
    Region    = "us-east-1"
  }
}
