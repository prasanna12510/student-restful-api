variable "azs" {}

variable "vpc_id" {}

variable "name" {}

variable vpc_endpoint_type {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}
variable "enable_ecr_api_endpoint" {
  description = "provision an ecr api endpoint to the VPC"
  type        = bool
}

variable "enable_ecr_dkr_endpoint" {
  description = "provision an ecr dkr endpoint to the VPC"
  type        = bool
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "securitygroup_id" {
  description = "An SG ID"
  default     = ""
}

variable "ecr_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for ECR dkr endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}
