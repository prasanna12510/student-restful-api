resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = var.key_name
  public_key = tls_private_key.main.public_key_openssh
}