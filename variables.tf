variable "instance_config" {
  type = object({
    instance_type = string
    region        = string
    ami           = string
    count         = number
  })
  default = {
    instance_type = "t2.micro"
    region        = "us-east-1a"
    ami           = "ami-0f9de6e2d2f067fca"
    count         = 1
  }
}

# variable "azs" {
#   type    = list(string)
#   default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
# }

# variable "vpc_cidr" {
#   type    = string
#   default = "10.0.0.0/16"
# }

# variable "public_subnets" {
#   type    = list(string)
#   default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
# }

# variable "private_subnets" {
#   type    = list(string)
#   default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24", "10.0.104.0/24"]
# }

# variable "db_subnets" {
#   type    = list(string)
#   default = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24", "10.0.204.0/24"]
# }