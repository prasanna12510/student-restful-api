resource "null_resource" "main" {
  triggers = {
    task_definition_arn = var.task_definition_arn
  }

  provisioner "local-exec" {
    command = <<EOT
      aws ecs run-task \
        --region ${var.region} \
        --cluster ${var.cluster_name} \
        --task-definition ${var.task_definition_arn} \
        --launch-type ${var.launch_type} \
        --network-configuration '{
          "awsvpcConfiguration": {
            "subnets": ${jsonencode(var.awsvpc_private_subnet_ids)},
            "securityGroups": ${jsonencode(var.awsvpc_security_group_ids)},
            "assignPublicIp": "DISABLED"
          }
        }'
EOT
  }
}
