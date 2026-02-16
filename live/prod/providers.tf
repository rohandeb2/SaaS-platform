terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Default provider for us-east-1
provider "aws" {
  region = "us-east-1"
}

# Aliased provider for eu-west-1
provider "aws" {
  region = "eu-west-1"
  alias  = "eu_west_1"
}
