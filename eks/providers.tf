terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      version = ">= 4.16.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}
