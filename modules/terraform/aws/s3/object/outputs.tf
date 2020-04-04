output "id" {
  value =  element(concat(aws_s3_bucket_object.this.*.id, [""]), 0)
}

output "etag" {
  value =  element(concat(aws_s3_bucket_object.this.*.etag, [""]), 0)
}

output "version_id" {
  value =  element(concat(aws_s3_bucket_object.this.*.version_id, [""]), 0)
}
