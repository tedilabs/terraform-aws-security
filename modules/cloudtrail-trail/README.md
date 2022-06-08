# cloudtrail-trail

This module creates following resources.

- `aws_cloudtrail`
- `aws_iam_role` (optional)
- `aws_iam_role_policy` (optional)
- `aws_iam_role_policy_attachment` (optional)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_resourcegroups_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group) | resource |
| [aws_route53_resolver_firewall_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_config) | resource |
| [aws_route53_resolver_firewall_rule_group_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_resolver_firewall_rule_group_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Required) The ID of the VPC which the firewall belongs to. | `string` | n/a | yes |
| <a name="input_fail_open_enabled"></a> [fail\_open\_enabled](#input\_fail\_open\_enabled) | (Optional) Determines how Route 53 Resolver handles queries during failures, for example when all traffic that is sent to DNS Firewall fails to receive a reply. By default, fail open is disabled, which means the failure mode is closed. This approach favors security over availability. DNS Firewall blocks queries that it is unable to evaluate properly. If you enable this option, the failure mode is open. This approach favors availability over security. DNS Firewall allows queries to proceed if it is unable to properly evaluate them. | `bool` | `false` | no |
| <a name="input_module_tags_enabled"></a> [module\_tags\_enabled](#input\_module\_tags\_enabled) | (Optional) Whether to create AWS Resource Tags for the module informations. | `bool` | `true` | no |
| <a name="input_resource_group_description"></a> [resource\_group\_description](#input\_resource\_group\_description) | (Optional) The description of Resource Group. | `string` | `"Managed by Terraform."` | no |
| <a name="input_resource_group_enabled"></a> [resource\_group\_enabled](#input\_resource\_group\_enabled) | (Optional) Whether to create Resource Group to find and group AWS resources which are created by this module. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Optional) The name of Resource Group. A Resource Group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with `AWS` or `aws`. | `string` | `""` | no |
| <a name="input_rule_groups"></a> [rule\_groups](#input\_rule\_groups) | (Optional) A list of rule groups associated with the firewall. Each value of `rule_group` block as defined below.<br>    (Required) `id` - The ID of the firewall rule group.<br>    (Required) `priority` - The setting that determines the processing order of the rule group among the rule groups that you associate with the specified VPC. DNS Firewall filters VPC traffic starting from the rule group with the lowest numeric priority setting.<br>    (Optional) `mutation_protection_enabled` - If enabled, this setting disallows modification or removal of the association, to help prevent against accidentally altering DNS firewall protections. | `any` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A map of tags to add to all resources. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fail_open_enabled"></a> [fail\_open\_enabled](#output\_fail\_open\_enabled) | Whether the Route53 Resolver handles queries during failures. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the firewall configuration. |
| <a name="output_owner_id"></a> [owner\_id](#output\_owner\_id) | The AWS Account ID of the owner of the VPC that this firewall applies to. |
| <a name="output_rule_groups"></a> [rule\_groups](#output\_rule\_groups) | The configuration of rule groups associated with the firewall. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The VPC ID which the firewall applies to. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
