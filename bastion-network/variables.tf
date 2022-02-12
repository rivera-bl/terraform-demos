variable "aws_region" {}
variable "proj_name" {}

variable "vpc_cidr" {}
variable "subnet_public_cidr" {}
variable "subnet_private_cidr" {}

variable "public_key_file" {
  type      = string
  default   = "~/.ssh/diplomado.pub"
  sensitive = true
}
