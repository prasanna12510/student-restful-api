variable "lambda_arn" {
  description = "lambda arn"
  type        = string
}

variable "event_source_arn" {
  description = "event source arn"
  type        = string
}

variable "starting_position" {
  description = "lambda event source read position"
  type        = string
  default     = "LATEST"
}
