# 1. Create a Security Group for VPC Endpoints
resource "aws_security_group" "vpc_endpoints" {
  name        = "acme-prod-use1-vpce-sg"
  description = "Security group for VPC Interface Endpoints"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Should match your vpc_cidr
  }

  tags = {
    Name = "acme-prod-use1-vpce-sg"
  }
}

# 1. Networking Layer
# 2. Update the Networking Layer module call
module "vpc" {
  source      = "../../../modules/networking"
  name_prefix = "acme-prod-use1"
  vpc_cidr    = "10.0.0.0/16"

  # Add this required line
  endpoint_sg_id = aws_security_group.vpc_endpoints.id

  tags = {
    Layer = "Networking"
  }
}

# 2. Security / Encryption Layer
resource "aws_kms_key" "rds" {
  description             = "KMS key for Aurora"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# 3. Compute Layer (ECS Fargate)
# Must be defined here so we can capture the Security Group ID
module "ecs_fargate" {
  source            = "../../../modules/compute"
  name_prefix       = "acme-prod-use1"
  region            = "us-east-1"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_subnet_ids    = module.vpc.app_subnet_ids
  
  container_image   = "123456789012.dkr.ecr.us-east-1.amazonaws.com/saas-api:latest"
  container_port    = 8080
}

# 4. Database Layer (Aurora)
module "aurora" {
  source = "../../../modules/database"

  name_prefix           = "acme-prod-use1"
  vpc_id                = module.vpc.vpc_id
  data_subnet_ids       = module.vpc.data_subnet_ids
  
  # Dependency resolved: Accessing the output from ecs_fargate
  app_security_group_id = module.ecs_fargate.service_sg_id 
  
  kms_key_arn           = aws_kms_key.rds.arn
  availability_zones    = ["us-east-1a", "us-east-1b"]
  
  tags = {
    Tier = "Data"
  }
}
