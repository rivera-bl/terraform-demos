# convert this file into a module that launchs an EC2 with the latest amazon linux2, and in the first subnet of the default vpc, add var for AWSManagedRole or custom Role from file, and var for user_data file + the vars already defined
data "aws_ssm_parameter" "this" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ami" "this" {
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.this.value]
  }
  most_recent = true
  owners      = ["amazon"]
}

resource "aws_key_pair" "this" {
  key_name   = var.proj_name
  public_key = file(var.public_key_file)
}

resource "aws_instance" "this" {
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.this.id
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = [for s in data.aws_subnet.this : s.id][0]
  vpc_security_group_ids      = [aws_security_group.this.id]
  user_data                   = file("${path.module}/files/user_data")
  iam_instance_profile        = aws_iam_instance_profile.this.name

  tags = {
    Name = var.proj_name
  }
}

resource "aws_security_group" "this" {
  name   = var.proj_name
  vpc_id = data.aws_vpc.this.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "${var.sg_ssh_allow_ip}/32"
    ]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.proj_name}"
  }
}

resource "aws_iam_role" "ec2-role" {
  name = "${var.proj_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          "Service" : "ec2.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3-full-access" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "kinesis-full-access" {
  role       = aws_iam_role.ec2-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.proj_name}-instance-profile"
  role = aws_iam_role.ec2-role.name
}
