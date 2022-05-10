locals {
  service_name = "Nodos"
}

module "ec2_instance_basic" {
  # source = "/home/rvv/dev/terraform/terraform-modules/terraform-aws-ec2-basic"
  source = "github.com/rivera-bl/terraform-modules//terraform-aws-ec2-basic"

  count_instances = 3
  service_name    = local.service_name
  user_data       = file("files/user_data.sh")
}
