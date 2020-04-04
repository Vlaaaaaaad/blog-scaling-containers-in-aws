locals {

  cluster_name = "fargate-eks"

  common_tags = {
    PartOf    = "fargate-eks"
    ManagedBy = "Terraform"
  }
}



terraform {
  required_version = ">= 0.12.23"

  backend "s3" {
    bucket = "vladionescu-scaling-tests"
    # Depending on where this runs,
    #  change this accordingly
    key = "eu-west-1/fargate-eks/terraform.tfstate"
    # key            = "us-east-1/fargate-eks/terraform.tfstate"
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

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  version          = "~> 1.11"
  load_config_file = false

  host = element(
    concat(
      data.aws_eks_cluster.cluster[*].endpoint,
      list("")
    ),
    0
  )

  cluster_ca_certificate = base64decode(
    element(
      concat(
        data.aws_eks_cluster.cluster[*].certificate_authority.0.data,
        list("")
      ),
      0
    )
  )

  token = element(
    concat(
      data.aws_eks_cluster_auth.cluster[*].token,
      list("")
    ),
    0
  )
}
