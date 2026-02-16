resource "aws_codepipeline" "this" {
  name     = "${var.name_prefix}-pipeline"
  role_arn = aws_iam_role.pipeline.arn

  artifact_store {
    location = var.artifact_bucket
    type     = "S3"
    region   = "us-east-1"
  }

  artifact_store {
    location = var.artifact_bucket_secondary
    type     = "S3"
    region   = "eu-west-1" # Replication happens automatically
  }

  stage {
    name = "Source"
    action {
      name             = "GitHub_Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration    = { Repo = var.repo, Branch = "main" }
    }
  }

  stage {
    name = "Deploy_Global"
    # Parallel Action 1: US-East-1
    action {
      name            = "Deploy_US"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      region          = "us-east-1"
      input_artifacts = ["build_output"]
      role_arn        = var.workload_account_role_arn
      configuration   = {
        ApplicationName                = var.codedeploy_app_us
        DeploymentGroupName            = var.codedeploy_group_us
        TaskDefinitionTemplateArtifact = "build_output"
        AppSpecTemplateArtifact        = "build_output"
      }
    }
    # Parallel Action 2: EU-West-1
    action {
      name            = "Deploy_EU"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      region          = "eu-west-1"
      input_artifacts = ["build_output"]
      role_arn        = var.workload_account_role_arn
      configuration   = {
        ApplicationName                = var.codedeploy_app_eu
        DeploymentGroupName            = var.codedeploy_group_eu
        TaskDefinitionTemplateArtifact = "build_output"
        AppSpecTemplateArtifact        = "build_output"
      }
    }
  }
}
