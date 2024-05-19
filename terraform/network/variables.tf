variable "vpc_cidr" {
  type        = string
}

variable "cidr_zero" {
  type = string
  default = "0.0.0.0/0"
}

variable "subnets" {
  type        = list(object({
    name=string,
    cidr=string,
    type=string,
    availability_zone=string

  }))
}