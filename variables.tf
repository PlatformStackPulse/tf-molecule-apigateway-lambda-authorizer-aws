variable "rest_api_id" {
  description = "ID of the REST API"
  type        = string
}

variable "authorizer_uri" {
  description = "Lambda invoke ARN for the authorizer"
  type        = string
}

variable "function_name" {
  description = "Lambda function name (for the lambda:InvokeFunction permission)"
  type        = string
}

variable "execution_arn" {
  description = "API Gateway execution ARN; used as source_arn prefix for the Lambda permission"
  type        = string
}

variable "identity_source" {
  description = "Source of the identity in an incoming request"
  type        = string
  default     = "method.request.header.Authorization"
}

variable "ttl_in_seconds" {
  description = "TTL in seconds for the authorizer result cache (0 to disable)"
  type        = number
  default     = 300
}
