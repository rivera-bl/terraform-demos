# BUCKET
resource "aws_s3_bucket" "this" {
  bucket = var.proj_name
  acl    = "private"
}

# OBJECT S3-ENCRYPTED
resource "aws_s3_bucket_object" "object-s3-encrypted" {
  for_each = fileset("${path.module}/${var.s3_object_files_dir}", "*")

  bucket                 = aws_s3_bucket.this.id
  key                    = "${each.value}-s3-encrypted"
  source                 = "${path.module}/${var.s3_object_files_dir}${each.value}"
  server_side_encryption = "aws:kms"

  etag = filemd5("${path.module}/${var.s3_object_files_dir}${each.value}")
}

# OBJECT KMS-ENCRYPTED
resource "aws_s3_bucket_object" "object-kms-encrypted" {
  for_each = fileset("${path.module}/${var.s3_object_files_dir}", "*")

  bucket     = aws_s3_bucket.this.id
  key        = "${each.value}-kms-encrypted"
  source     = "${path.module}/${var.s3_object_files_dir}${each.value}"
  kms_key_id = aws_kms_key.this.arn
}

resource "aws_kms_key" "this" {
  description             = var.proj_name
  deletion_window_in_days = 7
}
