terraform {
  backend "s3" {
    bucket         = "acme-terraform-state-prod-1"
    key            = "prod/multi-region-platform/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "acme-terraform-locks-prod-1"
  }
}
