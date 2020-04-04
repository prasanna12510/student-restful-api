# ---------------------------------------------------------------------------------------------------------------------
# CREATE A TARGET GROUP
# This will perform health checks on the servers and receive requests from the Listerers that match Listener Rules.
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_alb_target_group" "tg" {
  count = var.create_albtg ? 1 : 0
  name = var.target_groups[count.index]["name"]
  vpc_id = var.vpc_id
  port = var.target_groups[count.index]["backend_port"]
  protocol = upper(var.target_groups[count.index]["backend_protocol"])
  deregistration_delay = lookup(
  var.target_groups[count.index],
  "deregistration_delay",
  var.target_groups_defaults["deregistration_delay"],
  )
  target_type = lookup(
  var.target_groups[count.index],
  "target_type",
  var.target_groups_defaults["target_type"],
  )
  slow_start = lookup(
  var.target_groups[count.index],
  "slow_start",
  var.target_groups_defaults["slow_start"],
  )

  health_check {
    interval = lookup(
    var.target_groups[count.index],
    "health_check_interval",
    var.target_groups_defaults["health_check_interval"],
    )
    path = lookup(
    var.target_groups[count.index],
    "backend_path",
    var.target_groups_defaults["health_check_path"],
    )
    port = lookup(
    var.target_groups[count.index],
    "health_check_port",
    var.target_groups_defaults["health_check_port"],
    )
    healthy_threshold = lookup(
    var.target_groups[count.index],
    "health_check_healthy_threshold",
    var.target_groups_defaults["health_check_healthy_threshold"],
    )
    unhealthy_threshold = lookup(
    var.target_groups[count.index],
    "health_check_unhealthy_threshold",
    var.target_groups_defaults["health_check_unhealthy_threshold"],
    )
    timeout = lookup(
    var.target_groups[count.index],
    "health_check_timeout",
    var.target_groups_defaults["health_check_timeout"],
    )
    protocol = upper(
    lookup(
    var.target_groups[count.index],
    "healthcheck_protocol",
    var.target_groups[count.index]["backend_protocol"],
    ),
    )
    matcher = lookup(
    var.target_groups[count.index],
    "health_check_matcher",
    var.target_groups_defaults["health_check_matcher"],
    )
  }

  stickiness {
    type = "lb_cookie"
    cookie_duration = lookup(
    var.target_groups[count.index],
    "cookie_duration",
    var.target_groups_defaults["cookie_duration"],
    )
    enabled = lookup(
    var.target_groups[count.index],
    "stickiness_enabled",
    var.target_groups_defaults["stickiness_enabled"],
    )
  }

  tags = merge(
  var.tags,
  {
    "Name" = var.target_groups[count.index]["name"]
  },)
  lifecycle {
    create_before_destroy = true
  }
}
