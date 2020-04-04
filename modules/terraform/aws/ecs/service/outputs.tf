output "ecs_cluster_name" {
  value = aws_ecs_service.main.cluster
}

output "ecs_service" {
  value = aws_ecs_service.main.name
}
