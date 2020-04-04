output "id" {
  value       = element(concat(aws_lambda_function.this.*.id, [""]), 0)
}

output "arn" {
  value = element(concat(aws_lambda_function.this.*.arn, [""]), 0)
}

output "func_name" {
  value = element(concat(aws_lambda_function.this.*.function_name, [""]), 0)
}
