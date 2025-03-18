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
    count         = 4
  }
}