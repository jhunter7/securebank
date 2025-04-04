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
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.0.0/21", "10.0.8.0/21", "10.0.16.0/21", "10.0.24.0/21"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.32.0/21", "10.0.40.0/21", "10.0.48.0/21", "10.0.56.0/21"]
}

variable "db_subnets" {
  type    = list(string)
  default = ["10.0.64.0/21", "10.0.72.0/21", "10.0.80.0/21", "10.0.88.0/21"]
}