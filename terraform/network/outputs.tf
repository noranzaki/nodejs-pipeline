
output vpc_id{
    value=aws_vpc.myvpc.id
}
output "subnets"{
    value=aws_subnet.subnets
}