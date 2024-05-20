data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "bastion_host" {
    ami           = data.aws_ami.ubuntu.id
    instance_type=var.machine_type
    subnet_id=  module.network.subnets["public1"].id
    associate_public_ip_address = true
    vpc_security_group_ids=[aws_security_group.public_sg.id]
    key_name= aws_key_pair.my_key_pair.key_name
    user_data = <<-EOF
        #!/bin/bash
           echo "${tls_private_key.rsa_key.private_key_pem}" > /home/ubuntu/mykeypair.pem
           chmod 400 /home/ubuntu/mykeypair.pem
           chown ubuntu:ubuntu /home/ubuntu/mykeypair.pem
        EOF
    provisioner "local-exec" {
        command = "echo ${self.public_ip} >> bastionIP"
    }
    tags={
        Name="Bastion"
    }
}

resource "aws_instance" "application" {
    ami           = data.aws_ami.ubuntu.id
    instance_type=var.machine_type
    subnet_id=  module.network.subnets["private1"].id
    associate_public_ip_address = false
    vpc_security_group_ids=[aws_security_group.private_sg.id]
    key_name= aws_key_pair.my_key_pair.key_name
    tags={
        Name="Application"
    }
}
