provider "aws" {
  region = "us-west-2"
}

resource "aws_ecr_lifecycle_policy" "foopolicy" {
  count = length(var.ecr-repo-name)
  repository = "${element(var.ecr-repo-name, count.index)}-prod"

  policy = file("policy.tpl")
}
