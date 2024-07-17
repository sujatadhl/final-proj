resource "aws_codestarconnections_connection" "github-connection" {
  name          = "java-codestar"
  provider_type = "GitHub"
}
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "java-artifact"
}
resource "aws_codepipeline" "cicd_pipeline" {
  name       = "java-cicd_pipeline"
  role_arn   = module.iam_codepipeline.iam_role_arn
  depends_on = [module.db, module.asg, module.alb,aws_codestarconnections_connection.github-connection,aws_s3_bucket.codepipeline_bucket]
  pipeline_type = "V2"
  execution_mode = "QUEUED"
  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = 1
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github-connection.arn
        FullRepositoryId = "${var.repo_owner}/${var.repo_name}"
        BranchName       = var.repo_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name        
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = ["build_output"]
      version         = 1

      configuration = {
        ApplicationName     = aws_codedeploy_app.codedeploy_app.name
        DeploymentGroupName = aws_codedeploy_deployment_group.codedeploy_dg.deployment_group_name
      }
    }
  }
}
