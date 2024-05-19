resource "aws_db_subnet_group" "rds_subnet_group" {
  name          = "rds_subnet_group"
  subnet_ids = [
    module.network.subnets["private1"].id,
    module.network.subnets["private2"].id
  ]
}

resource "aws_db_instance" "mydb" {

    allocated_storage    = 10
    identifier              = "mydb"
    engine                  = "mysql"
    engine_version          = "8.0"
    instance_class          = "db.t3.micro"
    db_name                 = "mydb"
    username                = "admin"
    password                = var.db_pass
    db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
    skip_final_snapshot = true
    multi_az             = false
}