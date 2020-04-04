variable "availability-zones" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "env"  {
    default= {
        play= {
            APP_NAME = "student-api"
        },
        dev= {

        },
        prod= {

        },
        stag= {

        }
    }
}

variable "service-name" {
  description = "Tag: Service Name for all resources"
  default     = "student-api"
}
variable "owner" {
  description = "Tag: Owner of the resources"
  default     = "student-api"
}

variable "tag" {
  default = "APP_TAG"
}
