variable "description" {
  description = "lambda description"
  type        = string
  default     = null
}

variable "create_lambda"{}


variable "func_name" {
  description = "lambda function name"
  type        = string
}

variable "func_handler" {
  description = "lambda function handler"
  type        = string
}

variable "bucket_name" {
  description = "bucket name used to store lambda binary"
  type        = string
  default     = null
}

variable "bucket_key" {
  description = "path to lambda binary within the bucket"
  type        = string
  default     = null
}

variable "version_id" {
  description = "version id of s3 bucket"
  type        = string
  default     = null
}

variable "iam_role_arn" {
  description = "IAM role arn used to execute lambda"
  type        = string
}

variable "runtime" {
  description = "types of environment to run lambda, see https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  type        = string
}

variable "memory_size" {
  description = "how much memory allocated for lambda"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "how long lambda can run"
  type        = number
  default     = 3
}

variable "reserved_concurrent_executions" {
  description = "how many cuncurrent instance of lambda can run (0 means disable, -1 means no limit)"
  type        = number
  default     = 1
}

variable "vpc_subnet_ids" {
  description = "VPC subnets for lambda, when vpc access enabled"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "VPC security-groups for lambda, when vpc access enabled"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "resource tagging"
  type        = map(string)
  default     = {}
}

variable "filename" {
  description = "path to local lambda binary to be uploaded"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "map of environment variables"
  type        = map(string)
  default     = {}
}

variable "source_code_hash" {
  description = "source code hash"
  type = string
  default = null
}
