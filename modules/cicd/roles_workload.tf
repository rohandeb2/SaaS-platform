resource "aws_iam_role" "cross_account_deploy" {
  name = "${var.name_prefix}-cross-account-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::${var.cicd_account_id}:role/${aws_iam_role.pipeline.name}" }
      Action = "sts:AssumeRole"
    }]
  })
}

# Essential permissions for ECS Blue/Green
resource "aws_iam_role_policy" "deploy_perms" {
  role = aws_iam_role.cross_account_deploy.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ecs:DescribeServices",
          "ecs:UpdateService",
          "codedeploy:CreateDeployment",
          "codedeploy:GetDeployment",
          "s3:GetObject" # To pull artifacts from CI/CD bucket
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
