resource "aws_cloudwatch_event_rule" "this" {
  name        = var.project_name
  description = "Capture StopLogging events on Cloudtrail"

  event_pattern = <<EOF
{
  "source": ["aws.cloudtrail"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["cloudtrail.amazonaws.com"],
    "eventName": ["StopLogging"]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = aws_lambda_function.this.arn
  target_id = "${var.project_name}-lambda"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.this.name
  arn       = aws_sns_topic.this.arn
  target_id = "${var.project_name}-sns"
}
