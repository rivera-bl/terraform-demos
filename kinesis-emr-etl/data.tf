# this file should be reused across every terraform project because it contains the basic data we usually need to access
data "aws_caller_identity" "current" {}

data "aws_vpc" "this" {
  default = true
}

data "aws_subnet_ids" "this" {
  vpc_id = data.aws_vpc.this.id
}

data "aws_subnet" "this" {
  for_each = data.aws_subnet_ids.this.ids
  id       = each.value
}
