variable "create"{}


variable "statement_id" {
  description = "statement id of lambda function"
  type        = string
}


variable "function_name" {
  description = "lambda function name"
  type        = string
}

variable "principal" {
  description = "principal of lambda function"
  type        = string
}

variable "source_arn" {
  description = "source_arn of lambda function"
  type        = string
}

variable "action" {
  description = "actions to be performed by lambda"
  type        = string
  default     = "lambda:*"
}
