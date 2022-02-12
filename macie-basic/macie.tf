resource "aws_macie2_account" "this" {
  status = "ENABLED"
}

resource "aws_macie2_classification_job" "this" {
  job_type    = "SCHEDULED"
  initial_run = true
  name_prefix = var.proj_name

  schedule_frequency {
    daily_schedule = "true"
  }

  s3_job_definition {
    bucket_definitions {
      account_id = data.aws_caller_identity.this.account_id
      buckets    = [aws_s3_bucket.this.id]
    }
  }
  depends_on = [aws_macie2_account.this]
}

# # NOT TRUE uncomment this to do the remediation for the macie findings
# resource "aws_macie2_classification_job" "this2" {
#   job_type = "SCHEDULED"
#   initial_run = true
#   name_prefix     = "${var.proj_name}-remediacion"

#   schedule_frequency {
#     daily_schedule = "true"
#   }

#   s3_job_definition {
#     bucket_definitions {
#       account_id = data.aws_caller_identity.this.account_id
#       buckets    = [aws_s3_bucket.this.id]
#     }
#   }
#   depends_on = [aws_macie2_account.this]
# }

# resource "aws_cloudformation_stack" "this" {
#   name       = "${var.proj_name}-macie-cf"
#   on_failure = "DELETE"

#   parameters = {
#     ResourceName = "${var.proj_name}-macie-data"
#   }

#   template_body = file("${path.module}/files/amazon-macie-demo/macie.yml")

#   capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM"]
# }
