variable "bucket_name" {
  type        = string
  description = "bucket name"
}

variable "write_objects" {
  type        = list(map(string))
  description = <<DESC
  List of files to be uploaded to S3.

  [{
    source = "/home/user/project/lambda/build/worker.zip" // Required - local path
    key = "/lambda/worker.zip" // Required - S3 bucket key
  }]
DESC

  default = []
}
