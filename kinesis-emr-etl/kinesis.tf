# we are gonna use delivery streams and data streams
resource "aws_kinesis_stream" "this" {
  name = var.proj_name
  stream_mode_details { stream_mode = "ON_DEMAND" }
}

# bugged out? can't create it if i try to create it in the same terraform apply than the iam_role
resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = var.proj_name
  destination = "extended_s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.this.arn
    role_arn           = aws_iam_role.firehose-role.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose-role.arn
    bucket_arn = aws_s3_bucket.stream-bucket.arn
  }

  # this doesnt even works
  depends_on = [aws_iam_role.firehose-role]
}

resource "aws_iam_role" "firehose-role" {
  name = "${var.proj_name}-firehose-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          "Service" : "firehose.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_policy" "firehose-policy" {
  name        = "${var.proj_name}-firehose-policy"
  path        = "/"
  description = "Kinesis firehose policy to connect to Data Streams as Source and S3 Bucket as Destination"
  policy      = data.aws_iam_policy_document.firehose-document.json
}

resource "aws_iam_role_policy_attachment" "firehose-attachment" {
  role       = aws_iam_role.firehose-role.name
  policy_arn = aws_iam_policy.firehose-policy.arn
}

# generated with iam-policy-json-to-terraform_alpine < policies/kinesis-firehose-service-policy.json >> kinesis.tf
data "aws_iam_policy_document" "firehose-document" {
  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:catalog",
      "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:database/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
      "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:table/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
    ]

    actions = [
      "glue:GetTable",
      "glue:GetTableVersion",
      "glue:GetTableVersions",
    ]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.stream-bucket.id}",
      "arn:aws:s3:::${aws_s3_bucket.stream-bucket.id}/*",
    ]

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]

    actions = [
      "lambda:InvokeFunction",
      "lambda:GetFunctionConfiguration",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]

    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt",
    ]

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:s3:arn"

      values = [
        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%/*",
        "arn:aws:s3:::%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%",
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["s3.${var.region}.amazonaws.com"]
    }
  }

  # gotta comment this and create the firehose_delivery in another terraform apply, or it errors out
  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/kinesisfirehose/${aws_kinesis_firehose_delivery_stream.this.name}:log-stream:*",
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%:log-stream:*",
    ]

    actions = ["logs:PutLogEvents"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kinesis:${var.region}:${data.aws_caller_identity.current.account_id}:stream/${aws_kinesis_stream.this.name}"]

    actions = [
      "kinesis:DescribeStream",
      "kinesis:GetShardIterator",
      "kinesis:GetRecords",
      "kinesis:ListShards",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:kms:${var.region}:${data.aws_caller_identity.current.account_id}:key/%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"]
    actions   = ["kms:Decrypt"]

    condition {
      test     = "StringEquals"
      variable = "kms:ViaService"
      values   = ["kinesis.${var.region}.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "kms:EncryptionContext:aws:kinesis:arn"
      values   = ["arn:aws:kinesis:${var.region}:${data.aws_caller_identity.current.account_id}:stream/${aws_kinesis_stream.this.name}"]
    }
  }
}
