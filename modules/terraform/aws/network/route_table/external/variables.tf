variable "azs" {}

variable "vpc_id" {}

variable "name" {}

variable "gateway_id" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}
