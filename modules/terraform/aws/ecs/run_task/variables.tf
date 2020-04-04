variable "region" {
  description = "The AWS region. Default to ap-southeast-1."
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "The ECS cluster name."
  type        = string
}

variable "task_definition_arn" {
  description = "The task definition ARN."
  type        = string
}

variable "launch_type" {
  description = "The ECS launch type. Set to either FARGATE or EC2."
  type        = string
}

variable "awsvpc_private_subnet_ids" {
  description = "Private subnet ids to be used in awsvpc configuration"
  type        = list(string)
}

variable "awsvpc_security_group_ids" {
  description = "Security group ids to be used in awsvpc configuration"
  type        = list(string)
}
