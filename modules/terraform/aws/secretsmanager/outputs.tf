
output "private_registry_arn" {
  value = aws_secretsmanager_secret_version.private_registry_credential.arn
}