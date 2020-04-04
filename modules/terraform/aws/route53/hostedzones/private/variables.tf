variable "private_hostedzone" {
  default = ""
}

variable "comment" {}

variable "tags" {}

variable "name" {
  default = ""
}

variable "main_vpc_id" {
  default = ""
}

variable "secondary_vpc_id" {
default = ""
}

variable "attach_secondary_vpc_id" {
  default = false
  type = bool
}
variable "attach_main_vpc_id" {
  default = false
  type = bool
}

variable "private_hostedzone_id" {
  default = ""
}
