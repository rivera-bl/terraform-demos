variable "region" {}
variable "proj_name" {}

variable "sg_ssh_allow_ip" {
  type      = string
  sensitive = true
}
variable "public_key_file" {
  type      = string
  sensitive = true
}
