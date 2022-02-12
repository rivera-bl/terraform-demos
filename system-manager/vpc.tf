module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.proj_name
  cidr = var.vpc_cidr

  azs            = ["${var.aws_region}a"]
  public_subnets = var.vpc_public_subnets
}
