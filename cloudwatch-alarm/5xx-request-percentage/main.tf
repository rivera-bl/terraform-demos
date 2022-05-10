provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "lb_healthyhosts" {
  alarm_name          = "${var.app_name}${var.alarm_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.threshold
  alarm_description   = "Number of Unhealthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [var.sns_topic_arn]

  metric_query {
    id          = "e1"
    expression  = "(m1/m2)*100"
    label       = "Error Rate"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "HTTPCode_Target_5XX_Count"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        TargetGroup = var.dimensions_tg_arn_suffix 
        LoadBalancer = var.dimensions_lb_arn_suffix 
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "RequestCount"
      namespace   = "AWS/ApplicationELB"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        TargetGroup = var.dimensions_tg_arn_suffix 
        LoadBalancer = var.dimensions_lb_arn_suffix 
      }
    }
  }
}
