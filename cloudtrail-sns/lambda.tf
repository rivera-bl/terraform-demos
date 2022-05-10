data "archive_file" "this" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda_function.py"
  output_path = "${path.module}/lambda/lambda_function.zip"
}

resource "aws_lambda_function" "this" {
  filename      = "lambda/lambda_function.zip"
  function_name = var.project_name
  role          = aws_iam_role.this.arn
  runtime       = "python3.9"
  handler       = "lambda_handler"

  source_code_hash = filebase64sha256("lambda/lambda_function.py")

  # environment {
  #   variables = {
  #     foo = "bar"
  #   }
  # }
}

resource "aws_iam_role" "this" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
