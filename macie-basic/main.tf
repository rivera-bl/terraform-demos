provider "aws" {
  region = var.region
}

data "aws_caller_identity" "this" {}

# get vpc id
data "aws_vpc" "this" {
  default = true
}

# get subnets from vpc
data "aws_subnets" "this" {
  filter {
    name   = "vpc-id" # https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeSubnets.html
    values = [data.aws_vpc.this.id]
  }
}

# convert values
data "aws_subnet" "this" {
  for_each = toset(data.aws_subnets.this.ids)
  id       = each.value
}

# # use on resource
# output "test" {
#   value = [for s in data.aws_subnet.this : s.id][0]
# }
