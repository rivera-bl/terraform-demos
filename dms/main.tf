provider "aws" {
  region = "us-east-1"
}

# variable "subnet_cidrs" {
#   default = [ 
#       "100.66.96.0/22", 
#       "100.66.100.0/22"
#     ]
# }

variable "vpc_id" {
  default = "vpc-05d50f9389b042331"
}

variable "subnet_ids" {
  default = [ 
    "subnet-00afac7d90bc74a1d",
    "subnet-0a43bf5fff373ca57",
    "subnet-03f99413a48844f9e"
    ]
}

#############
### DMS
#############

# TODO vpc_security_group_ids
resource "aws_dms_replication_instance" "this" {
  replication_instance_id     = "defectdojo"
  allocated_storage           = 20
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  engine_version              = "3.4.7"
  replication_instance_class  = "dms.t3.large"
  replication_subnet_group_id = aws_dms_replication_subnet_group.this.replication_subnet_group_id

	depends_on = [aws_iam_role.dms-vpc-role]
}

resource "aws_dms_replication_subnet_group" "this" {
  replication_subnet_group_id          = "defectdojo-subnet-group"
  replication_subnet_group_description = "defectdojo-subnet-group"
  subnet_ids                           = var.subnet_ids
}

# resource "aws_dms_replication_task" "this" {
#   replication_task_id            = "this-replication-task"
#   migration_type                 = "full-load-and-cdc"
#   source_endpoint_arn            = "arn:aws:dms:us-east-1:123456789012:endpoint:1234567890123456"
#   target_endpoint_arn            = "arn:aws:dms:us-east-1:123456789012:endpoint:1234567890123457"
#   replication_instance_arn       = aws_dms_replication_instance.this.arn
#   replication_subnet_group_id    = aws_dms_replication_subnet_group.this.id
#   table_mappings                 = file("${path.module}/table-mappings.json")
# }

#############
### IAM
#############

data "aws_iam_policy_document" "dms_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["dms.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "dms-vpc-role" {
  assume_role_policy = "${data.aws_iam_policy_document.dms_assume_role.json}"
  name               = "dms-vpc-role"
}

resource "aws_iam_role_policy_attachment" "dms-vpc-role-AmazonDMSVPCManagementRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonDMSVPCManagementRole"
  role       = "${aws_iam_role.dms-vpc-role.name}"
}
