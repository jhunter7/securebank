resource "aws_instance" "securebank_instance" {
  count = var.instance_config.count

  ami                    = var.instance_config.ami
  instance_type          = var.instance_config.instance_type
  availability_zone      = var.instance_config.region
  vpc_security_group_ids = [aws_security_group.securebank_instance_sg.id]
  key_name               = "securebnk-keypair"

  tags = {
    Name = "securebank-instance-${count.index + 1}"
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



# resource "aws_instance" "securebank_instance" {
#   provider = aws.east
#   count    = var.instance_config["east"].count

#   ami                    = var.instance_config["east"].ami
#   instance_type          = var.instance_config["east"].instance_type
#   availability_zone      = var.instance_config["east"].region
#   vpc_security_group_ids = [aws_security_group.securebank_instance_sg.id]

#   ebs_block_device {
#     device_name           = "/dev/sdh"
#     volume_size           = 20
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "securebank-e1-${count.index + 1}"
#   }
# }

# resource "aws_instance" "securebank_instance_west" {
#   provider = aws.west
#   count    = var.instance_config["west"].count

#   ami                    = var.instance_config["west"].ami
#   instance_type          = var.instance_config["west"].instance_type
#   availability_zone      = var.instance_config["west"].region
#   vpc_security_group_ids = [aws_security_group.securebank_instance_sg.id]

#   ebs_block_device {
#     device_name           = "/dev/sdh"
#     volume_size           = 20
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   tags = {
#     Name = "securebank-w2-${count.index + 1}"
#   }
# }

# resource "aws_security_group" "securebank_instance_sg_west" {
#   provider    = aws.west
#   name        = "securebank_instance_sg-west"
#   description = "Allow SSH access for west instances"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["172.2.163.205/32", "44.204.68.63/32"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

