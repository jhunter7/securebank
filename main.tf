resource "aws_instance" "securebank_instance" {
  count = var.instance_config.count

  ami               = var.instance_config.ami
  instance_type     = var.instance_config.instance_type
  availability_zone = var.instance_config.region

  tags = {
    Name = "instance-${each.key}-${count.index + 1}"
  }
}

resource "aws_security_group" "github_runner_sg" {
  name        = "github-runner-sg"
  description = "Allow SSH access for GitHub runner"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.2.163.205/32", "44.204.68.63/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance (free-tier eligible) for GitHub Runner; note that this is a separate instance
resource "aws_instance" "github_runner" {
  ami           = "ami-0f9de6e2d2f067fca" 
  instance_type = "t2.micro"              
  key_name      = "kms_key"     

  vpc_security_group_ids = [aws_security_group.github_runner_sg.id]

  tags = {
    Name = "SecureBank"
  }
}