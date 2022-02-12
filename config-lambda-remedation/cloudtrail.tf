data "aws_caller_identity" "current" {}

# resource "aws_cloudwatch_log_group" "this" {
#   name = var.project_name
# }

resource "aws_cloudtrail" "this" {
  name                          = var.project_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
  # cloud_watch_logs_role_arn = aws_iam_role.this.arn
  # cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.this.arn}:*"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "${var.project_name}-cloudtrail-logs"
  force_destroy = true

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${var.project_name}-cloudtrail-logs"
        },
        {
            "Sid": "AWSCloudTrailWrite",
            "Effect": "Allow",
            "Principal": {
              "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${var.project_name}-cloudtrail-logs/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}

# resource "aws_iam_role" "this" {
#   name = var.project_name

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "cloudtrail.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy" "this" {
#   name = var.project_name
#   role = aws_iam_role.this.id

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "AWSCloudTrailCreateLogStream2014110",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogStream"
#             ],
#             "Resource": [
#                 "${aws_cloudwatch_log_group.this.arn}:*"
#             ]
#         },
#         {
#             "Sid": "AWSCloudTrailPutLogEvents20141101",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:PutLogEvents"
#             ],
#             "Resource": [
#                 "${aws_cloudwatch_log_group.this.arn}:*"
#             ]
#         }
#     ]
# }
# EOF
# }
