<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.36 |

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_listener_certificate_arn"></a> [listener\_certificate\_arn](#input\_listener\_certificate\_arn) | ARN of the default SSL server certificate. Exactly one certificate is required if the protocol is HTTPS | `string` | `null` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | Port on which the load balancer is listening. Not valid for Gateway Load Balancers | `number` | `null` | no |
| <a name="input_listener_protocol"></a> [listener\_protocol](#input\_listener\_protocol) | Protocol for connections from clients to the load balancer. For Application Load Balancers, valid values are HTTP and HTTPS, with a default of HTTP. For Network Load Balancers, valid values are TCP, TLS, UDP, and TCP\_UDP. Not valid to use UDP or TCP\_UDP if dual-stack mode is enabled. Not valid for Gateway Load Balancers. | `string` | `"HTTP"` | no |
| <a name="input_listener_ssl_policy"></a> [listener\_ssl\_policy](#input\_listener\_ssl\_policy) | Name of the SSL Policy for the listener. Required if protocol is HTTPS or TLS | `string` | `null` | no |
| <a name="input_load_balancer_arn"></a> [load\_balancer\_arn](#input\_load\_balancer\_arn) | AWS Load Balancer ARN | `string` | n/a | yes |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | AWS Load Balancer Type - this variable is used in ssl\_policy and certificate\_arn conditions | `string` | `"application"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_listener_arn"></a> [listener\_arn](#output\_listener\_arn) | n/a |
| <a name="output_listener_port"></a> [listener\_port](#output\_listener\_port) | n/a |
| <a name="output_listener_protocol"></a> [listener\_protocol](#output\_listener\_protocol) | n/a |
| <a name="output_listener_ssl_policy"></a> [listener\_ssl\_policy](#output\_listener\_ssl\_policy) | n/a |
<!-- END_TF_DOCS -->