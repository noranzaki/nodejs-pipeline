variable vpc_cidr {
  type        = string
}

variable "cidr_zero" {
  type          = string
  default="0.0.0./0"
}

variable machine_type {
  type        = string
}

variable region {
  type        = string
}

variable "subnets" {
  type        = list(object({
    name=string,
    cidr=string,
    type=string,
    availability_zone=string

  }))
}

variable "db_pass" {
  type      = string
  sensitive = true
}