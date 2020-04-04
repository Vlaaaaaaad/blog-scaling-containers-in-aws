locals {
  common_tags = {
    PartOf    = "shared"
    ManagedBy = "Terraform"
  }
}

terraform {
  required_version = ">= 0.12"

  backend "s3" {
    bucket         = "vladionescu-scaling-tests"
    key            = "shared/ecr/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  alias   = "us"
  version = "~> 2.0"

  region = "us-east-1"
}

provider "aws" {
  alias   = "eu"
  version = "~> 2.0"

  region = "eu-west-1"
}

data "aws_caller_identity" "current" {
  provider = aws.us
}
