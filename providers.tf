terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Primary Region: US East (N. Virginia)
provider "aws" {
  region = "us-east-1"
  
  # Default tags applied to all resources in this region
  default_tags {
    tags = {
      Project     = "SaaS-Platform"
      Environment = "prod"
      ManagedBy   = "terraform"
      Region      = "us-east-1"
    }
  }
}

# Secondary Region: Europe (Ireland)
provider "aws" {
  region = "eu-west-1"
  alias  = "eu_west_1"

  default_tags {
    tags = {
      Project     = "SaaS-Platform"
      Environment = "prod"
      ManagedBy   = "terraform"
      Region      = "eu-west-1"
    }
  }
}
