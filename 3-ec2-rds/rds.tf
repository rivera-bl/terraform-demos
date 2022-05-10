resource "aws_db_instance" "this" {
  identifier             = "kibernumdb"
  engine                 = "mariadb"
  engine_version         = "10.6.7"
  instance_class         = "db.t2.micro"
  db_name                = "kibernumdb"
  username               = "admin"
  password               = "adminadmin"
  storage_type           = "gp2"
  allocated_storage      = 20
  skip_final_snapshot    = true
  port                   = 3306
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = "default.mariadb10.6"
}

resource "aws_security_group" "this" {
  name   = "${local.service_name}-rds-sg"
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    # cidr_blocks = module.ec2_instance_basic.instance_public_ip
    cidr_blocks = formatlist("%s/32", module.ec2_instance_basic.instance_private_ip)
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
}
