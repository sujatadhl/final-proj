module "autoscaling_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  # Alarm details
  alarm_name            = "cpu-utilization-high"
  comparison_operator   = "GreaterThanOrEqualToThreshold"
  evaluation_periods    = "2"
  threshold             = 70
  period                = "60"
  unit                  = "Milliseconds"
  namespace             = "AWS/EC2"
  metric_name           = "StatusCheckFailed_Instance"
  statistic             = "Sum"

  alarm_actions = [
    module.sns_topic.topic_arn
  ]
}

module "alb_healthcheck"{
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = "status-code-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300 
  statistic           = "Sum"
  threshold           = 10   
  alarm_description   = "Alarm when 5XX error count on target group exceeds 10 over 5 minutes"

  dimensions = {
    TargetGroup  = module.alb.aws_lb_target_group
  }

  alarm_actions = module.sns_topic.topic_arn 
}
