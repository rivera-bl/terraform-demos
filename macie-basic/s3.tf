resource "aws_s3_bucket" "this" {
  bucket = "${var.proj_name}-macie"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "this" {
  for_each = fileset("${path.module}/files/amazon-macie-demo/data", "*")

  bucket = aws_s3_bucket.this.id
  key    = "data/${each.value}"
  source = "${path.module}/files/amazon-macie-demo/data/${each.value}"
  # # NOT TRUE uncomment this to do the remediation for the macie findings
  # server_side_encryption = "AES256"

  etag = filemd5("${path.module}/files/amazon-macie-demo/data/${each.value}")
}
