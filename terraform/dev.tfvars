vpc_cidr  = "10.0.0.0/16"
region    = "eu-west-1"
cidr_zero = "0.0.0.0/0"
machine_type= "t3.micro"
subnets = [

  {
    name              = "public1",
    cidr              = "10.0.1.0/24",
    type              = "public",
    availability_zone = "eu-west-1a"
  },
  {
    name              = "public2",
    cidr              = "10.0.2.0/24",
    type              = "public",
    availability_zone = "eu-west-1b"
  },

  {
    name              = "private1",
    cidr              = "10.0.3.0/24",
    type              = "private",
    availability_zone = "eu-west-1a"
  },
  {
    name              = "private2",
    cidr              = "10.0.4.0/24",
    type              = "private",
    availability_zone = "eu-west-1b"
  }

]
#database password
db_pass = "12345678"