resource "aws_cloudformation_stack" "config-rule" {
  name       = "${var.project_name}-config-rule"
  on_failure = "DELETE"

  parameters = {
    S3bucket = aws_s3_bucket.lambdas.id
    Email    = var.my_email
  }

  template_body = file("${path.module}/files/CF-CONFIG-RULE.yaml")

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]

  depends_on = [aws_cloudformation_stack.config-remedation]
}

resource "aws_cloudformation_stack" "config-remedation" {
  name       = "${var.project_name}-config-remedation"
  on_failure = "DELETE"

  parameters = {
    S3bucket   = aws_s3_bucket.lambdas.id
    Exclusions = aws_s3_bucket.lambdas.id
    Email      = var.my_email
  }

  template_body = file("${path.module}/files/CF-CONFIG-REMEDATION.yaml")

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
}
