output "pipeline_arn" {
  value       = aws_codepipeline.this.arn
  description = "ARN of the AWS CodePipeline created for CI/CD"
}

output "codebuild_project_name" {
  value       = aws_codebuild_project.docker_build.name
  description = "Name of the AWS CodeBuild project used for building Docker images"
}

