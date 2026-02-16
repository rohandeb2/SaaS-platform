# live/prod/main.tf

data "terraform_remote_state" "us_east" {
  backend = "s3"
  config = {
    bucket = "acme-terraform-state-prod-1" # Use your real bucket name
    key    = "prod/multi-region-platform/terraform.tfstate"
    region = "us-east-1" # The region where the BUCKET lives
  }
}

data "terraform_remote_state" "eu_west" {
  backend = "s3"
  config = {
    bucket = "acme-terraform-state-prod-1" # Use your real bucket name
    key    = "prod/multi-region-platform/terraform.tfstate"
    region = "us-east-1" # The region where the BUCKET lives
  }
}


module "security_baseline" {
  source = "../../modules/security-baseline"
  
  name_prefix           = "acme-sec-prod"
  config_bucket_name    = "acme-config-logs-prod"
  security_alerts_email = "admin@example.com"

  providers = {
    aws.us_east_1 = aws
    aws.eu_west_1 = aws.eu_west_1
  }
}

module "edge_stack" {
  source          = "../../modules/edge"
  name_prefix     = "saas-global"

  primary_region = "us-east-1"      # WAF/CloudFront must be managed here
  domain_name    = "example.com"    # Your actual domain for SSL/Route53

  # Pass data from the regional states
  us_alb_dns_name = "acme-prod-use1-alb-12345.us-east-1.elb.amazonaws.com"
  us_alb_arn      = "arn:aws:elasticloadbalancing:us-east-1:889501007925:loadbalancer/app/acme-alb/abc"
  eu_alb_dns_name = "acme-prod-euw1-alb-67890.eu-west-1.elb.amazonaws.com"
  eu_alb_arn      = "arn:aws:elasticloadbalancing:eu-west-1:889501007925:loadbalancer/app/acme-alb/xyz"
}
