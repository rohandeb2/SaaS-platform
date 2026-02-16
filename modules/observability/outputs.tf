# --- CloudWatch & Alerting ---
output "log_group_arn" {
  description = "The ARN of the central application log group"
  value       = aws_cloudwatch_log_group.app.arn
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic for critical alerts"
  value       = aws_sns_topic.alerts.arn
}

# --- Distributed Tracing (X-Ray) ---
output "xray_sampling_rule_arn" {
  description = "The ARN of the X-Ray sampling rule"
  value       = aws_xray_sampling_rule.app.arn
}

# --- OpenSearch (Logs & Search) ---
output "opensearch_domain_arn" {
  description = "The ARN of the OpenSearch domain"
  value       = aws_opensearch_domain.this.arn
}

output "opensearch_endpoint" {
  description = "The endpoint for submitting index or search requests"
  value       = aws_opensearch_domain.this.endpoint
}

output "opensearch_dashboard_endpoint" {
  description = "The URL for the OpenSearch Dashboard (Kibana)"
  value       = aws_opensearch_domain.this.dashboard_endpoint
}

# --- Managed Prometheus (AMP) ---
output "prometheus_workspace_id" {
  description = "The identifier for the AMP workspace"
  value       = aws_prometheus_workspace.this.id
}

output "prometheus_endpoint" {
  description = "The Prometheus endpoint for querying and remote writes"
  value       = aws_prometheus_workspace.this.prometheus_endpoint
}

# --- Managed Grafana (AMG) ---
output "grafana_workspace_id" {
  description = "The identifier for the Grafana workspace"
  value       = aws_grafana_workspace.this.id
}

output "grafana_endpoint" {
  description = "The URL to access the Grafana console"
  value       = aws_grafana_workspace.this.endpoint
}
