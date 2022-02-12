resource "aws_instance" "private" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.this.key_name
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private.id]

  tags = {
    Name = "${var.proj_name}-private"
  }
}

resource "aws_security_group" "private" {
  name   = "${var.proj_name}-private"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.proj_name}-private"
  }
}
