# Molecule: API Gateway Lambda Authorizer (REQUEST type + Lambda Permission)
# Creates a Lambda REQUEST authorizer and grants API Gateway permission to invoke it.

resource "aws_api_gateway_authorizer" "this" {
  count = module.this.enabled ? 1 : 0

  name                             = module.this.id
  rest_api_id                      = var.rest_api_id
  type                             = "REQUEST"
  authorizer_uri                   = var.authorizer_uri
  identity_source                  = var.identity_source
  authorizer_result_ttl_in_seconds = var.ttl_in_seconds
}

resource "aws_lambda_permission" "this" {
  count = module.this.enabled ? 1 : 0

  statement_id  = "AllowAPIGatewayInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.execution_arn}/authorizers/*"
}
