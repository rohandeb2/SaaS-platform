resource "aws_xray_sampling_rule" "app" {
  rule_name      = "${var.name_prefix}-sampling-rule"
  priority       = 1000
  version        = 1
  reservoir_size = 1    # 1 request per second
  fixed_rate     = 0.05 # 5% thereafter
  url_path       = "*"
  host           = "*"
  http_method    = "*"
  service_type   = "*"
  service_name   = "*"
  resource_arn   = "*"
}
