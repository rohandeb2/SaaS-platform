# modules/networking/endpoints.tf

# 1. Update S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.id}.s3" # Changed .name to .id
  route_table_ids = concat(
    [aws_route_table.public.id],
    aws_route_table.private[*].id
  )
}

# 2. Update DynamoDB Gateway Endpoint
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${data.aws_region.current.id}.dynamodb" # Changed .name to .id
  route_table_ids = concat(
    [aws_route_table.public.id],
    aws_route_table.private[*].id
  )
}

# 3. Update Interface Endpoints (ECR, Secrets Manager, Logs)
resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each            = toset(["ecr.api", "ecr.dkr", "secretsmanager", "logs"])
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.id}.${each.key}" # Changed .name to .id
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.app[*].id
  security_group_ids  = [var.endpoint_sg_id]
}

data "aws_region" "current" {}
