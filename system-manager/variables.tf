variable "aws_region" {}
variable "proj_name" {}
variable "vpc_cidr" {}
variable "vpc_public_subnets" {}

variable "public_key_file" {
  type      = string
  default   = "~/.ssh/diplomado.pub"
  sensitive = true
}
