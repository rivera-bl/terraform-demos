resource "aws_iam_role" "this" {
  name               = var.proj_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name = var.proj_name
  }
}

resource "aws_iam_instance_profile" "this" {
  name = var.proj_name
  role = aws_iam_role.this.id
}

resource "aws_iam_policy_attachment" "this" {
  name       = var.proj_name
  roles      = [aws_iam_role.this.id]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# resource "aws_iam_policy_attachment" "this" {
#   name       = var.proj_name
#   roles      = [aws_iam_role.this.id]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
# }
