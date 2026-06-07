output "authorizer_id" {
  description = "ID of the created API Gateway Lambda authorizer"
  value       = module.authorizer.authorizer_id
}

output "authorizer_arn" {
  description = "ARN of the created API Gateway Lambda authorizer"
  value       = module.authorizer.authorizer_arn
}
