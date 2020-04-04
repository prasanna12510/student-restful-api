output "target_group_arns" {
  description = "ARNs of the target groups. Useful for passing to your Auto Scaling group."
  value =  element(concat(aws_alb_target_group.tg.*.arn, [""]), 0)
}
output "target_group_arn_suffix" {
  description = "ARN suffixes of our target groups - can be used with CloudWatch."
  value = element(concat(aws_alb_target_group.tg.*.arn_suffix, [""]), 0)
}

output "target_group_name" {
  description = "Name of the target group. Useful for passing to your CodeDeploy Deployment Group."
  value =  element(concat(aws_alb_target_group.tg.*.name, [""]), 0)
}
