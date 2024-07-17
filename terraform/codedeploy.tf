resource "aws_codedeploy_app" "codedeploy_app" {
  compute_platform = "Server"
  name             = "java-application"
}

resource "aws_codedeploy_deployment_group" "codedeploy_dg" {
  app_name              = aws_codedeploy_app.codedeploy_app.name
  deployment_group_name = "java-deployment-group"
  service_role_arn      = module.iam_codedeploy.iam_role_arn
  autoscaling_groups    = [module.asg.autoscaling_group_name]
  depends_on = [ module.vpc, module.iam_codebuild, aws_codestarconnections_connection.github-connection]

  deployment_style {
    deployment_type   = "IN_PLACE"
  }
  load_balancer_info {
    target_group_info {
      name = module.alb.target_group_names[0]
    }
  }
  
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

}