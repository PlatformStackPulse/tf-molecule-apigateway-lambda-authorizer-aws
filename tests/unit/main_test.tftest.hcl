# Unit Tests — tf-molecule-apigateway-lambda-authorizer-aws
#
# These tests use a mock AWS provider — no real AWS calls are made.
# Run with:         terraform test -test-directory=tests/unit
# Run verbose:      terraform test -test-directory=tests/unit -verbose
# Run specific:     terraform test -test-directory=tests/unit -run "creates_when_enabled"
#
# NOTE: The module's real outputs (authorizer_id, authorizer_arn) are computed
# by child atom modules and are UNKNOWN under a mock provider, so we assert on
# plan-KNOWN values only (tf-label id + input pass-throughs).

mock_provider "aws" {}

variables {
  # tf-label identity (namespace-stage-name => "eg-test-thing")
  namespace = "eg"
  stage     = "test"
  name      = "thing"

  # Module-required inputs (valid sample values)
  rest_api_id    = "abc123defg"
  authorizer_uri = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:123456789012:function:eg-test-thing-authorizer/invocations"
  function_name  = "eg-test-thing-authorizer"
  execution_arn  = "arn:aws:execute-api:eu-west-1:123456789012:abc123defg"
}

# ---------------------------------------------------------------------------
# Test: module plans successfully when enabled and wires inputs through
# ---------------------------------------------------------------------------
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = module.this.id == "eg-test-thing"
    error_message = "tf-label id should be 'eg-test-thing' from namespace/stage/name."
  }

  assert {
    condition     = module.this.enabled == true
    error_message = "Module should be enabled by default."
  }

  assert {
    condition     = var.ttl_in_seconds == 300 && var.identity_source == "method.request.header.Authorization"
    error_message = "Authorizer defaults (ttl=300, Authorization header identity source) should apply."
  }
}

# ---------------------------------------------------------------------------
# Test: disabled context produces no id (creates nothing)
# ---------------------------------------------------------------------------
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = module.this.id == ""
    error_message = "When disabled, tf-label id should be empty (no resources created)."
  }
}
