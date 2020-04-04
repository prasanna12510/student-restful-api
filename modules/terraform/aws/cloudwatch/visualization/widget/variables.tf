variable "region" {
  default     = "ap-southeast-1"
  description = "The AWS Region"
  type        = string
}

variable "dimensions" {
  description = "A comma separated list of DimensionNames and DimensionsValues. Due to a limitation in Terraform, nested lists can't be passed through modules. :("
  type = list
  default = []
}

variable "metric_name" {}

variable "namespace" {}


variable "height" {
  default = 6
}

variable "width" {
  default = 6
}

variable "period" {
  default = 300
}

variable "stacked" {
  default = false
}

variable "stat" {
  default = "Average"
}

variable "title" {
  default = false
}

variable "view" {
  default = "timeSeries"
}
