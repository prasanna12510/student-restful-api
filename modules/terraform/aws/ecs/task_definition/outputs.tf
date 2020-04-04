output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.main.arn
}

output "ecs_task_definition_family" {
  value = aws_ecs_task_definition.main.family
}

output "ecs_task_definition_latest" {
  value = "${aws_ecs_task_definition.main.family}:${max("${aws_ecs_task_definition.main.revision}")}"
}

output "container_definition_json" {
  description = "JSON encoded container definitions for use with other terraform resources such as aws_ecs_task_definition"
  value       = "[${local.container_definition_json}]"
}
