<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.36 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.39.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lb_listener_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | n/a | `string` | `null` | no |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | AWS Load Balancer listener arn identifier | `string` | n/a | yes |
| <a name="input_listener_rules"></a> [listener\_rules](#input\_listener\_rules) | A list of http listener rules configurations | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags | `map(string)` | `{}` | no |
| <a name="input_target_group_arn"></a> [target\_group\_arn](#input\_target\_group\_arn) | AWS Load Balancer Target Group ARN | `string` | `null` | no |
<!-- END_TF_DOCS -->