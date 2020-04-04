variable "azs" {}

variable "vpc_id" {}

variable "name" {}

variable "private_routetable_id" {}

variable "service_name" {}

variable "end_point_type" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}