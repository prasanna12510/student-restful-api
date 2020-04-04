locals {
  # Sort environment variables so terraform will not try to recreate on each plan/apply
  env_vars             = var.environment != null ? var.environment : []
  env_vars_keys        = [for m in local.env_vars : lookup(m, "name")]
  env_vars_values      = [for m in local.env_vars : lookup(m, "value")]
  env_vars_as_map      = zipmap(local.env_vars_keys, local.env_vars_values)
  sorted_env_vars_keys = sort(local.env_vars_keys)

  sorted_environment_vars = [
    for key in local.sorted_env_vars_keys :
    {
      name  = key
      value = lookup(local.env_vars_as_map, key)
    }
  ]

  null_value = var.environment == null ? var.environment : null

  final_environment_vars = length(local.sorted_environment_vars) > 0 ? local.sorted_environment_vars : local.null_value

  container_definition = {
    name                   = var.container_name
    image                  = var.container_image
    essential              = var.essential
    entryPoint             = var.entrypoint
    command                = var.command
    workingDirectory       = var.working_directory
    readonlyRootFilesystem = var.readonly_root_filesystem
    mountPoints            = var.mount_points
    dnsServers             = var.dns_servers
    ulimits                = var.ulimits
    repositoryCredentials  = var.repository_credentials
    links                  = var.links
    volumesFrom            = var.volumes_from
    user                   = var.user
    dependsOn              = var.container_depends_on
    privileged             = var.privileged
    portMappings           = var.port_mappings
    healthCheck            = var.healthcheck
    firelensConfiguration  = var.firelens_configuration
    linuxParameters        = var.linux_parameters
    logConfiguration       = var.log_configuration
    memory                 = var.container_memory
    memoryReservation      = var.container_memory_reservation
    cpu                    = var.container_cpu
    environment            = local.final_environment_vars
    secrets                = var.secrets
    dockerLabels           = var.docker_labels
    startTimeout           = var.start_timeout
    stopTimeout            = var.stop_timeout
    systemControls         = var.system_controls
  }

  container_definition_json = jsonencode(local.container_definition)
}



resource "aws_ecs_task_definition" "main" {
  family                   = var.task_definition_name
  container_definitions    = "[${local.container_definition_json}]"
  task_role_arn            = var.ecs_task_role
  execution_role_arn       = var.ecs_task_execution_role
  requires_compatibilities = var.task_requires_compatibilities
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  network_mode             = var.task_network_mode
  tags                     = merge({ "Name" = format("%s", var.task_definition_name) },var.tags)

  dynamic "placement_constraints" {
    for_each = var.task_placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "volume" {
    for_each = var.volumes
    content {
      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
