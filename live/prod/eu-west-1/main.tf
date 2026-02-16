# 1. Networking Layer (Referencing the local Ireland VPC module)
module "vpc" {
  source         = "../../../modules/networking"
  name_prefix    = "acme-prod-euw1"
  vpc_cidr       = "10.1.0.0/16" # Different CIDR to allow for peering
  endpoint_sg_id = aws_security_group.vpc_endpoints.id

  tags = {
    Layer = "Networking"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "acme-prod-euw1-vpce-sg"
  description = "Security group for VPC Interface Endpoints in EU"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }
}

# 2. Security / Encryption Layer (Replica Key)
# Note: Use the replica key from the global security module for RDS encryption
data "aws_kms_key" "rds_replica" {
  key_id = "alias/acme-sec-prod-kms-replica" # Created in Phase 1
}

# 3. Compute Layer (ECS Fargate)
module "ecs_fargate" {
  source            = "../../../modules/compute"
  name_prefix       = "acme-prod-euw1"
  region            = "eu-west-1"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  app_subnet_ids    = module.vpc.app_subnet_ids
  
  # Ensure your image is available in eu-west-1 ECR
  container_image   = "123456789012.dkr.ecr.eu-west-1.amazonaws.com/saas-api:latest"
  container_port    = 8080
}

# 4. Database Layer (Aurora Secondary/Replica)
module "aurora_secondary" {
  source = "../../../modules/database"

  name_prefix           = "acme-prod-euw1"
  vpc_id                = module.vpc.vpc_id
  data_subnet_ids       = module.vpc.data_subnet_ids
  app_security_group_id = module.ecs_fargate.service_sg_id 
  
  kms_key_arn           = data.aws_kms_key.rds_replica.arn
  availability_zones    = ["eu-west-1a", "eu-west-1b"]
  
  # Configuration for Global Cluster Membership
  # Ensure the primary cluster name matches your US deployment
  global_cluster_identifier = "acme-prod-global-db" 
  
  tags = {
    Tier = "Data"
    Role = "Secondary"
  }
}
