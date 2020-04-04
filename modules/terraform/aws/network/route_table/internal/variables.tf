variable "azs" {}

variable "vpc_id" {}

variable "name" {}

#variable "nat_gateway_count" {}

variable "max_subnet_length" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}

variable "attach_natgateway" {
  description = "Controls if nat gateway attachment is needed or not"
  type        = bool
}

variable "subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "subnet_ids" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "gateway_id" {
  type = list(string)
  default = []
}
