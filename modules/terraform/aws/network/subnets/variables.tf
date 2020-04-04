variable "azs" {}

variable "vpc_id" {}

variable "name" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}

variable "subnets_cidr" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}
