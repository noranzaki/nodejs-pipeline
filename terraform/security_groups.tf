resource "aws_security_group" "public_sg" {
    name        = "public_sg"
    description = "Allow ssh traffic"
    vpc_id= module.network.vpc_id
    
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = [var.cidr_zero]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        cidr_blocks = [var.cidr_zero]
        from_port = 22
        to_port = 22
        protocol = "tcp"
    }
}

resource "aws_security_group" "private_sg" {
    name        = "private_sg"
    description = "Allow ssh and port 3000 from vpc cidr only"
    vpc_id= module.network.vpc_id
    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = [var.cidr_zero]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        cidr_blocks = [var.vpc_cidr]
        from_port = 3000
        to_port = 3000
        protocol = "tcp"
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.vpc_cidr]
    }

}


resource "aws_security_group" "rds_sg" {
  vpc_id = module.network.vpc_id
  name   = "rds_sg"

  ingress {
    from_port   = 3306  
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_zero]  
  }

}

resource "aws_security_group" "elasticache_sg" {
  vpc_id = module.network.vpc_id
  name   = "elasticache_sg"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_zero]
  }
}
