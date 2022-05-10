provider "aws" {
  region = "us-west-2"
}

resource "aws_cloudwatch_metric_alarm" "this" {
  count               = length(var.app_name)
  alarm_name          = "${element(var.app_name, count.index)}${var.alarm_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Maximum"
  threshold           = var.threshold
  alarm_description   = "Triggers when Status Checks Fails on EC2 Instance"
  actions_enabled     = "true"
# https://docs.aws.amazon.com/AmazonCloudWatch/latest/APIReference/API_PutMetricAlarm.html
  alarm_actions       = [
                          var.sns_topic_arn,
                          "arn:aws:automate:us-west-2:ec2:reboot"
                        ]
  dimensions = {
    InstanceId  = "${element(var.dimensions_ec2_id, count.index)}"
  }
}
