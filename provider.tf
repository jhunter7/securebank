terraform {
  backend "s3" {
    bucket         = "jetops-tfstate"
    key            = "terraform/github-runner/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "tf-lock-table"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "east"
}

provider "aws" {
  region = "us-west-2"
  alias  = "west"
}

locals {
  regions = {
    east = aws.east
    west = aws.west
  }
}