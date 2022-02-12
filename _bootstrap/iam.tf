data "aws_caller_identity" "current" {}

resource "aws_iam_user" "this" {
  name = "pabloriv"
  # path = "/system/"

  # tags = {
  #   tag-key = "tag-value"
  # }
}

# just API credentials?
resource "aws_iam_access_key" "this" {
  user    = aws_iam_user.this.name
  pgp_key = "keybase:${var.keybase_user}"
}

resource "aws_iam_user_login_profile" "this" {
  user    = aws_iam_user.this.id
  pgp_key = "keybase:${var.keybase_user}"
}

# the same as aws_iam_policy, but we dont need to create the iam_user_policy_attachment
resource "aws_iam_user_policy" "this" {
  name = "${var.project_name}-assume-role-user-policy"
  user = aws_iam_user.this.name

  # policy = file("${path.module}/files/assume-role-user-policy.json")

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [ "sts:AssumeRole" ],
      "Effect": "Allow",
      "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.this.name}"
    }
  ]
}
EOF
}

resource "aws_iam_role" "this" {
  name = "${var.project_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = { "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
