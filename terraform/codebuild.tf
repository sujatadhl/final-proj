resource "aws_codebuild_project" "codebuild" {
  name         = "java_cicd_build"
  description  = "Code Build"
  service_role = module.iam_codebuild.iam_role_arn
  depends_on = [ module.vpc, module.iam_codebuild, aws_codestarconnections_connection.github-connection ]

  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    environment_variable {
      name = "SECRETS_ID" 
      value = module.db.db_instance_master_user_secret_arn
    }
     environment_variable {
      name = "RDS_HOSTNAME" 
      value = module.db.db_instance_address
    }
    environment_variable {
      name = "RDS_PORT" 
      value = module.db.db_instance_port
    }     
    environment_variable {
      name = "RDS_DB_NAME" 
      value = module.db.db_instance_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    location = aws_s3_bucket.codepipeline_bucket.bucket
    buildspec = "buildspec.yml"
  }
  logs_config {
      cloudwatch_logs {
        status     = "ENABLED"
        group_name = "/aws/codebuild/java_cicd_build"
        }
    }
     cache {
    type     = "S3"
    location = aws_s3_bucket.java-log-bucket.bucket
  }
  vpc_config {
    vpc_id = module.vpc.vpc_id

    subnets = module.vpc.database_subnets 
    

    security_group_ids = [
      module.security-group.security_group_id
    ]
  }  
}
