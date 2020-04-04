data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh")
  vars = {
    environment = var.environment
    cluster_name = var.cluster_name
    ecs_image_pull_behavior = var.ecs_image_pull_behavior
    ecs_disable_image_cleanup = var.ecs_disable_image_cleanup
    ecs_image_cleanup_interval = var.ecs_image_cleanup_interval
    ecs_image_minimum_cleanup_age = var.ecs_image_minimum_cleanup_age
    ecs_num_images_delete_per_cycle = var.ecs_num_images_delete_per_cycle
    ecs_engine_task_cleanup_wait_duration = var.ecs_engine_task_cleanup_wait_duration
    prefix_name  = var.service
    cloudwatch_prefix = var.cloudwatch_prefix
    private_registry_token = var.private_registry_token
  }
}

resource "aws_launch_configuration" "main" {
  associate_public_ip_address = true
  name_prefix                 = "${var.name}-"
  iam_instance_profile        = var.iam_instance_profile
  instance_type               = var.instance_type
  security_groups             = ["${var.security_groups}"]
  image_id                    = var.ami_id
  user_data                   = data.template_file.user_data.rendered

  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = true
    volume_type = var.volume_type
  }
  ebs_block_device {
    device_name = var.ebs_external_device
    no_device = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
