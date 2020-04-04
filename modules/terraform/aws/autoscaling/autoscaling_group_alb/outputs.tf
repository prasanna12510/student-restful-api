output "aws_asg_id" {
  value = aws_autoscaling_group.main.id
}

output "aws_asg_name" {
  value = aws_autoscaling_group.main.name
}

output "vpc" {
  value = aws_autoscaling_group.main.vpc_zone_identifier
}
