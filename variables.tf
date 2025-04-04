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

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/14"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/18", "10.0.64.0/18", "10.0.128.0/18", "10.0.192.0/18"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.1.0.0/18", "10.1.64.0/18", "10.1.128.0/18", "10.1.192.0/18"]
}

variable "db_subnets" {
  type    = list(string)
  default = ["10.2.0.0/18", "10.2.64.0/18", "10.2.128.0/18", "10.2.192.0/18"]
}
