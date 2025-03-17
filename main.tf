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
}

# Security Group for SSH access (adjust CIDR for production)
resource "aws_security_group" "github_runner_sg" {
  name        = "github-runner-sg"
  description = "Allow SSH access for GitHub runner"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.2.163.205/32","44.204.68.63/32"]  # Replace with your IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (free-tier eligible)
resource "aws_instance" "github_runner" {
  ami           = "ami-0f9de6e2d2f067fca"  # Ubuntu 20.04 LTS in us-east-1; update if needed
  instance_type = "t2.micro"               # Free-tier eligible
  key_name      = "jetops-gha-runner"       # Replace with your AWS key pair name

  vpc_security_group_ids = [aws_security_group.github_runner_sg.id]

  tags = {
    Name = "GitHubRunner"
  }
}
