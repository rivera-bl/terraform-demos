provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "lb_healthyhosts" {
  alarm_name          = "${var.app_name}${var.alarm_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.threshold
  alarm_description   = "Number of Unhealthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [var.sns_topic_arn]
  dimensions = {
    TargetGroup  = var.dimensions_tg_arn_suffix
    LoadBalancer = var.dimensions_lb_arn_suffix
  }
}
