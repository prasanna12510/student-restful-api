##################################################### Deprecated ###################################################
resource "aws_secretsmanager_secret" "private_registry_credential" {
  name = "private_registry_credential"
  description = "Private registry credentials"
}

resource "aws_secretsmanager_secret_version" "private_registry_credential" {
  secret_id     = aws_secretsmanager_secret.private_registry_credential.id
  secret_string = "{\"username\":\"${var.user_name}\",\"password\":\"${var.user_token}\"}"
}
