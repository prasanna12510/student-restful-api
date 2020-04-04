variable "name" {
  description = "Launch Config name"
}

variable "instance_type" {
  description = "Instance type"
}

variable "security_groups" {
  description = "Security group to be attached on instance"
}

variable "ami_id" {
  description = "AMI For Launch Config"
}

variable "tags" {
  default = ""
}

variable "root_volume_size" {
  default = ""
}

variable "cluster_name" {
  default = ""
}

variable "iam_instance_profile" {
  default = ""
}


variable "keypair_name" {
  default = ""
}

variable "service" {
  default = ""
}

variable "cloudwatch_prefix" {
  default = ""
}

variable "private_registry_token" {
  default = ""
}

variable "environment" {
  default = ""
}

variable "elastic_cloudid" {
  default = ""
}

variable "elastic_cloudpassword" {
  default = ""
}

variable "aws_accesskey" {
  default = ""
}
variable "aws_secretkey" {
  default = ""
}
variable "region" {
  default = "ap-southeast-1"
}

variable "elasticsearch_url" {
  default = ""
}
variable "volume_type" {
  default = "gp2"
}

variable "ebs_external_device" {
  default = "/dev/xvdcz"
}

variable "cloudwatch_custommetric_version" {
  default = ""
}


variable "ecs_image_pull_behavior" {
  description = "The behavior used to customize the pull image process for your container instances."
  default     = "once"
  type        = string
}

variable "ecs_disable_image_cleanup" {
  description = "Whether to disable automated image cleanup for the Amazon ECS agent. For more information."
  default     = false
  type        = bool
}

variable "ecs_image_cleanup_interval" {
  description = "The time interval between automated image cleanup cycles. If set to less than 10 minutes, the value is ignored."
  default     = "30m"
  type        = string
}

variable "ecs_image_minimum_cleanup_age" {
  description = "The minimum time interval between when an image is pulled and when it can be considered for automated image cleanup."
  default     = "1h"
  type        = string
}

variable "ecs_num_images_delete_per_cycle" {
  description = "The maximum number of images to delete in a single automated image cleanup cycle. If set to less than 1, the value is ignored."
  default     = 5
  type        = number
}

variable "ecs_engine_task_cleanup_wait_duration" {
  description = "Time duration to wait from when a task is stopped until the Docker container is removed. As this removes the Docker container data, be aware that if this value is set too low, you may not be able to inspect your stopped containers or view the logs before they are removed. The minimum duration is 1m; any value shorter than 1 minute is ignored."
  default     = "5m"
  type        = string
}


variable "ecs_enable_container_metadata" {
  description = "When true, the agent creates a file describing the container's metadata. The file can be located and consumed by using the container environment variable $ECS_CONTAINER_METADATA_FILE."
  default     = true
  type        = bool
}
