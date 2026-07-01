# tf-molecule-apigateway-lambda-authorizer-aws

Terraform molecule (PlatformStackPulse) that provisions an **API Gateway REQUEST Lambda authorizer** and grants API Gateway permission to invoke the authorizer Lambda.

## Features

- Creates a **REQUEST-type** API Gateway Lambda authorizer wired to a REST API.
- Grants the `lambda:InvokeFunction` permission so API Gateway can invoke the authorizer function (`apigateway.amazonaws.com` principal, scoped to `.../authorizers/*`).
- Configurable **identity source** (defaults to `method.request.header.Authorization`).
- Configurable **result-cache TTL** (defaults to 300s; set to `0` to disable caching).
- Consistent naming, tagging, and `enabled` toggling via the shared [tf-label](https://github.com/PlatformStackPulse/tf-label) context.
- Composed from pinned atom modules (`tf-atom-apigateway-authorizer-aws`, `tf-atom-lambda-permission-aws`) at fixed SHAs.

## Usage

```hcl
module "authorizer" {
  source = "git::https://github.com/PlatformStackPulse/tf-molecule-apigateway-lambda-authorizer-aws.git?ref=v1.0.0"

  # tf-label context
  namespace = "eg"
  stage     = "prod"
  name      = "api"

  # Required wiring
  rest_api_id    = aws_api_gateway_rest_api.this.id
  authorizer_uri = aws_lambda_function.authorizer.invoke_arn
  function_name  = aws_lambda_function.authorizer.function_name
  execution_arn  = aws_api_gateway_rest_api.this.execution_arn

  # Optional
  identity_source = "method.request.header.Authorization"
  ttl_in_seconds  = 300
}
```

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

### Providers

No providers.

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_authorizer"></a> [authorizer](#module\_authorizer) | git::https://github.com/PlatformStackPulse/tf-atom-apigateway-authorizer-aws.git | 36f0d7ab61657ea34898b9dfd6f16b4840e2f604 |
| <a name="module_permission"></a> [permission](#module\_permission) | git::https://github.com/PlatformStackPulse/tf-atom-lambda-permission-aws.git | f9cb20f9bfbff65fbc58b9f7eacafc418375aef0 |
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/PlatformStackPulse/tf-label.git | v1.0.0 |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorizer_uri"></a> [authorizer\_uri](#input\_authorizer\_uri) | Lambda invoke ARN for the authorizer | `string` | n/a | yes |
| <a name="input_execution_arn"></a> [execution\_arn](#input\_execution\_arn) | API Gateway execution ARN; used as source\_arn prefix for the Lambda permission | `string` | n/a | yes |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Lambda function name (for the lambda:InvokeFunction permission) | `string` | n/a | yes |
| <a name="input_rest_api_id"></a> [rest\_api\_id](#input\_rest\_api\_id) | ID of the REST API | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes and tags, which are merged. | <pre>object({<br/>    enabled             = optional(bool, true)<br/>    namespace           = optional(string, null)<br/>    tenant              = optional(string, null)<br/>    environment         = optional(string, null)<br/>    stage               = optional(string, null)<br/>    name                = optional(string, null)<br/>    delimiter           = optional(string, null)<br/>    attributes          = optional(list(string), [])<br/>    tags                = optional(map(string), {})<br/>    label_order         = optional(list(string), null)<br/>    regex_replace_chars = optional(string, null)<br/>    id_length_limit     = optional(number, null)<br/>    label_key_case      = optional(string, null)<br/>    label_value_case    = optional(string, null)<br/>    labels_as_tags      = optional(set(string), null)<br/>    descriptor_formats = optional(map(object({<br/>      format = string<br/>      labels = list(string)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | <pre>map(object({<br/>    format = string<br/>    labels = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'. | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` to keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_identity_source"></a> [identity\_source](#input\_identity\_source) | Source of the identity in an incoming request | `string` | `"method.request.header.Authorization"` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>Note: The value of the `name` tag, if included, will be the `id`, not the `name`. | `set(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A customer identifier, indicating who this instance of a resource is for. | `string` | `null` | no |
| <a name="input_ttl_in_seconds"></a> [ttl\_in\_seconds](#input\_ttl\_in\_seconds) | TTL in seconds for the authorizer result cache (0 to disable) | `number` | `300` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_authorizer_arn"></a> [authorizer\_arn](#output\_authorizer\_arn) | ARN of the created API Gateway Lambda authorizer |
| <a name="output_authorizer_id"></a> [authorizer\_id](#output\_authorizer\_id) | ID of the created API Gateway Lambda authorizer |
<!-- END_TF_DOCS -->

## Tests

Unit tests use a mock AWS provider (no real AWS calls, no credentials) and run under `terraform test`. They assert on plan-known values — the tf-label `id` and input/default pass-throughs — since the module's computed outputs (`authorizer_id`, `authorizer_arn`) are unknown under a mock provider.

```bash
# Unit tests (mock provider)
terraform init -backend=false
terraform test -test-directory=tests/unit

# or via Makefile
make test-unit
```

Integration tests (`tests/integration/`) run against real AWS and require credentials:

```bash
terraform test -test-directory=tests/integration
```
