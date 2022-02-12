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
