# Molecule: API Gateway Lambda Authorizer (REQUEST type + Lambda Permission)
# Creates a Lambda REQUEST authorizer and grants API Gateway permission to invoke it.

module "authorizer" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-apigateway-authorizer-aws.git?ref=36f0d7ab61657ea34898b9dfd6f16b4840e2f604"

  context                          = module.this.context
  rest_api_id                      = var.rest_api_id
  type                             = "REQUEST"
  authorizer_uri                   = var.authorizer_uri
  identity_source                  = var.identity_source
  authorizer_result_ttl_in_seconds = var.ttl_in_seconds
}

module "permission" {
  source = "git::https://github.com/PlatformStackPulse/tf-atom-lambda-permission-aws.git?ref=f9cb20f9bfbff65fbc58b9f7eacafc418375aef0"

  context       = module.this.context
  attributes    = ["authorizer"]
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.execution_arn}/authorizers/*"
}
