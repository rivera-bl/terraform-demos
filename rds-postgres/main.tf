provider "aws" {
  region     = "us-east-1"
}

variable "subnet_cidrs" {
  default = [ 
      "172.18.14.0/25",
      "172.18.14.128/25",
      "172.18.15.0/26",
      "100.66.96.0/22", 
      "100.66.100.0/22"
    ]
}

variable "subnet_ids" {
  default = [ 
    "subnet-03f99413a48844f9e",
    "subnet-00afac7d90bc74a1d",
    "subnet-0a43bf5fff373ca57"
    ]
}

resource "aws_db_subnet_group" "this" {
  name       = "main"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Dependency Track subnet group"
  }
}

resource "aws_db_instance" "this" {
  identifier             = "dependency-track"
  engine                 = "postgres"
  engine_version         = "14.6"
  instance_class         = "db.m5.large"
  db_name                = "dt"
  username               = ""
  password               = ""
  storage_type           = "gp2"
  allocated_storage      = 40
  skip_final_snapshot    = true
  port                   = 5432
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = "default.postgres14"
  db_subnet_group_name   = aws_db_subnet_group.this.name
}

# TODO allow connection with Vault
resource "aws_security_group" "this" {
  name   = "dependency-track-rds-to-helios-eks"
  vpc_id = "vpc-05d50f9389b042331"

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    cidr_blocks = var.subnet_cidrs  
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
}

output "rds_endpoints" {
  value = aws_db_instance.this.endpoint
}   
