resource "aws_s3_bucket" "app-bucket" {
  bucket = "${var.proj_name}-app"
  acl    = "private"
}

resource "aws_s3_bucket" "stream-bucket" {
  bucket        = "${var.proj_name}-streams"
  acl           = "private"
  force_destroy = true

  # necessary to comment this to force_destroy properly
  # lifecycle {
  #    prevent_destroy = true
  # }
}

# do we really need to save all the app files in S3? can't we just store them on github?
resource "aws_s3_bucket_object" "app-objects" {
  for_each = fileset("${path.module}/app", "**")

  bucket = aws_s3_bucket.app-bucket.id
  key    = "s3base/${each.value}"
  source = "${path.module}/app/${each.value}"

  etag = filemd5("${path.module}/app/${each.value}")
}
