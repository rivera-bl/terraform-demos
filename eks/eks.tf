# this is necessary for the authentication with the cluster to work for terraform
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
  }
}

module "eks" {
  source                          = "terraform-aws-modules/eks/aws"
  version                         = "18.21.0"
  cluster_name                    = var.cluster_name
  cluster_version                 = "1.21"
  subnet_ids                      = module.vpc.private_subnets
  cluster_endpoint_private_access = true

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {}

  # should have a blue/green configuration for updating nodes
  eks_managed_node_groups = {

    basic = {
      # cant use remote_access if we create a launch template
      create_launch_template = false
      launch_template_name   = ""

      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["m5.large"]
      capacity_type  = "ON_DEMAND"

      remote_access = {
        ec2_ssh_key               = aws_key_pair.this.key_name
        source_security_group_ids = [aws_security_group.remote_access.id]
      }
    }
  }

  manage_aws_auth_configmap = true

  # aws_auth_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::66666666666:role/role1"
  #     username = "role1"
  #     groups   = ["system:masters"]
  #   },
  # ]

  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user1"
  #     username = "user1"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     userarn  = "arn:aws:iam::66666666666:user/user2"
  #     username = "user2"
  #     groups   = ["system:masters"]
  #   },
  # ]

  # aws_auth_accounts = [
  #   "777777777777",
  #   "888888888888",
  # ]
}

resource "aws_key_pair" "this" {
  key_name_prefix = var.cluster_name
  public_key      = file("~/.ssh/ec2-common.pub")
}

resource "aws_security_group" "remote_access" {
  name_prefix = "${var.cluster_name}-remote-access"
  description = "Allow remote SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "190.45.104.205/32"
    ]
  }
}
