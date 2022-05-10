resource "aws_config_config_rule" "this" {
  name = "${var.proj_name}-config"

  # https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html
  source {
    owner             = "AWS"
    source_identifier = "INCOMING_SSH_DISABLED"
  }

  depends_on = [aws_config_configuration_recorder.config_recorder]
}
