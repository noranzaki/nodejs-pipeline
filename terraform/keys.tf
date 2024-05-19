resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "my_key_pair" {
  key_name   = "mykeypair"
  public_key = tls_private_key.rsa_key.public_key_openssh
}

resource "local_file" "private_key_file" {
  content       = tls_private_key.rsa_key.private_key_pem
  filename      = "mykeypair.pem"
  file_permission = "0400"
}
