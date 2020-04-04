resource "aws_autoscaling_group" "main" {
  launch_configuration = var.launch_config_name
  vpc_zone_identifier = var.vpc
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_capacity
  health_check_type = var.health_check_type
  name = var.name
  termination_policies = ["${var.termination_policy}", "${var.default_as_termination_policy}"]
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown
  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }

  tag {
    key                 = "service_name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "owner"
    value               = var.owner
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = var.environment
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
