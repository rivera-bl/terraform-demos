resource "aws_s3_bucket" "lambdas" {
  bucket        = var.project_name
  force_destroy = true
}

resource "aws_s3_bucket_object" "this" {
  for_each = fileset("${path.module}/files", "*.zip")

  bucket = aws_s3_bucket.lambdas.id
  key    = each.value
  source = "${path.module}/files/${each.value}"

  etag = filemd5("${path.module}/files/${each.value}")
}
