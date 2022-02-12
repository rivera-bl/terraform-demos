resource "aws_vpc" "this" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.proj_name
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = var.proj_name
  }
}

# PUBLIC SUBNET
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_public_cidr

  tags = {
    Name = "${var.proj_name}-public"
  }
}

# PRIVATE SUBNET
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.subnet_private_cidr

  tags = {
    Name = "${var.proj_name}-private"
  }
}

# the local target route is added by default
resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = var.proj_name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.this.id
}

# resource "aws_route_table_association" "private" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.this.id
# }
