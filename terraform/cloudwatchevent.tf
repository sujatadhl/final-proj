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