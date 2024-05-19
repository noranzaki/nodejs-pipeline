#-----vpc----#
resource "aws_vpc" "myvpc" {
  cidr_block= var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "myvpc"
  }
}

#-----subnets----#
resource "aws_subnet" "subnets" {
    for_each = { for subnet in var.subnets : subnet.name => subnet }

    vpc_id            = aws_vpc.myvpc.id
    cidr_block        = each.value.cidr
    availability_zone = each.value.availability_zone
    tags = {
        Name = "${each.value.name}"
    }
}

#------route tables-----#
resource "aws_route_table" "route_tables" {
  count=2
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block =  var.cidr_zero
    gateway_id = count.index == 0? aws_internet_gateway.my-igw.id:aws_nat_gateway.my-ngw.id
  }
  tags = {
    Name = count.index == 0? "public_rtb": "private_rtb"
  }
}
resource "aws_route_table_association" "subnet_association" {
 
  for_each = { for s, subnet in var.subnets : s => subnet }

  subnet_id      = aws_subnet.subnets[each.value.name].id
  route_table_id = each.value.type == "public" ? aws_route_table.route_tables[0].id : aws_route_table.route_tables[1].id
  provisioner "local-exec" {
    command = "echo ${each.value.name}"
  }

}

#------nat gateway----#
resource "aws_eip" "myeip" {
    domain= "vpc"
    tags={
        "Name" = "myeip"
    } 
}

resource "aws_nat_gateway" "my-ngw" {
    allocation_id = aws_eip.myeip.id
    subnet_id     = aws_subnet.subnets["public1"].id
    tags={
        Name = "my-ngw"
    } 
}

#-----internet gateway------#
resource "aws_internet_gateway" "my-igw" {
    vpc_id=aws_vpc.myvpc.id
    tags = {
    Name = "my-igw"
    }
}