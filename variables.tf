variable "instance_configs" {
  type = map(object({
    instance_type = string
    region        = string
    ami           = string
    count         = number
  }))
  default = {
    east = {
      instance_type = "t2.micro"
      region        = "us-east-1a"
      ami           = "ami-0f9de6e2d2f067fca"
      count         = 3
    },
    west = {
      instance_type = "t2.micro"
      region        = "us-west-2a"
      ami           = "ami-03f8acd418785369b"
      count         = 2
    }
  }
}