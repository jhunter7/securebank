resource "aws_instance" "securebank_instance" {
  provider = aws.east
  count    = 3

  ami                    = var.instance_config.ami
  instance_type          = var.instance_config.instance_type
  availability_zone      = var.instance_config.region
  vpc_security_group_ids = [aws_security_group.securebank_instance_sg.id]

  tags = {
    Name = "securebank-${count.index + 1}"
  }
}

resource "aws_instance" "securebank_instance_west" {
  provider = aws.west
  count    = 2

  ami                    = var.instance_config.ami
  instance_type          = var.instance_config.instance_type
  availability_zone      = var.instance_config.region
  vpc_security_group_ids = [aws_security_group.securebank_instance_sg.id]

  tags = {
    Name = "securebank-${count.index + 1}"
  }
}

resource "aws_security_group" "securebank_instance_sg" {
  name        = "securebank_instance_sg"
  description = "Allow SSH access for instances"

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