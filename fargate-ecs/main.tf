locals {
  cluster_name = "fargate-ecs"

  common_tags = {
    PartOf    = "fargate-ecs"
    ManagedBy = "Terraform"
  }
}



terraform {
  required_version = ">= 0.12.23"

  backend "s3" {
    bucket = "vladionescu-scaling-tests"
    # Depending on where this runs,
    #  change this accordingly
    key = "eu-west-1/fargate-ecs/terraform.tfstate"
    # key            = "us-east-1/fargate-ecs/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

provider "aws" {
  version = "~> 2.0"

  # Depending on where this runs,
  #  change this accordingly
  region = "eu-west-1"
  # region = "us-east-1"
}



data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}
