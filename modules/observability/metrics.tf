# Amazon Managed Prometheus (AMP)
resource "aws_prometheus_workspace" "this" {
  alias = "${var.name_prefix}-prometheus"
}

# Amazon Managed Grafana (AMG)
resource "aws_grafana_workspace" "this" {
  name                     = "${var.name_prefix}-grafana"
  account_access_type      = "CURRENT_ACCOUNT"
  authentication_providers = ["AWS_SSO"] # Best practice for production
  permission_type          = "SERVICE_MANAGED"
  data_sources             = ["CLOUDWATCH", "PROMETHEUS", "XRAY"]
}
