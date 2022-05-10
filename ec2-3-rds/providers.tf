provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Name     = local.service_name
      Owner    = "Pablo"
      Language = "php"
    }
  }
}
