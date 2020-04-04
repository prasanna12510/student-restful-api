output "ec2_keypair_name" {
  value = aws_key_pair.generated_key.key_name
}
output "ec2_publickey_ssh" {
  value = tls_private_key.main.public_key_openssh
}

output "ec2_publickey_pem" {
  value = tls_private_key.main.public_key_pem
}

output "ec2_privatekey_pem" {
  value = tls_private_key.main.private_key_pem
  sensitive = true
}
