resource "aws_s3_bucket_object" "this" {
  count = length(var.write_objects)
  bucket = var.bucket_name
  key    = lookup(var.write_objects[count.index], "key")
  source = lookup(var.write_objects[count.index], "source")
}
