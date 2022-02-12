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
  count                       = 2
  associate_public_ip_address = true
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.this.id
  key_name                    = aws_key_pair.this.key_name
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.this.id]
  iam_instance_profile        = aws_iam_role.this.name

  tags = {
    Name = var.proj_name
  }
}
