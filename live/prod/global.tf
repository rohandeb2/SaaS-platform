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
