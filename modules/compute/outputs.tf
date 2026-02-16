output "alb_dns_name" {
  value       = aws_lb.main.dns_name
  description = "The DNS name of the Load Balancer"
}

output "alb_zone_id" {
  value       = aws_lb.main.zone_id
  description = "The Zone ID of the ALB for Route53 Alias records"
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_service_name" {
  value = aws_ecs_service.api.name
}

output "blue_target_group_name" {
  value = aws_lb_target_group.blue.name
}

output "green_target_group_name" {
  value = aws_lb_target_group.green.name
}

output "service_sg_id" {
  value = aws_security_group.ecs_service.id
}
