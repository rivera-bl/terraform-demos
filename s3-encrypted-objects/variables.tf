variable "aws_region" {}
variable "proj_name" {}
variable "s3_object_files_dir" {}

variable "secret" {
  default = {
    secret-key = "secret-value"
  }

  sensitive = true
  type      = map(string)
}
