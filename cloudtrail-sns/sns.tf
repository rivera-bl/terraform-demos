resource "aws_sns_topic" "this" {
  name = var.project_name
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.email
}
