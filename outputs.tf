output "authorizer_id" {
  description = "ID of the created API Gateway Lambda authorizer"
  value       = one(aws_api_gateway_authorizer.this[*].id)
}

output "authorizer_arn" {
  description = "ARN of the created API Gateway Lambda authorizer"
  value       = one(aws_api_gateway_authorizer.this[*].arn)
}
