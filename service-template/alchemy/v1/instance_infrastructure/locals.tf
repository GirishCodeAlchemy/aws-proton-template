locals {

  /**
 * Environment Configuration
 */

  region               = "us-east-2"
  environment          = "sbox"
  deployment_version   = "1x0"
  resource_name_prefix = "tb-${var.build_number}-${local.environment}-${local.deployment_version}"
  provisioned_by_tag   = "alchemy-cloudops"
  iam_module_version   = "?ref=release/iam-1.0"
  service_inputs       = zipmap(keys(var.service_instance.inputs), [for config_value in values(var.service_instance.inputs) : jsondecode(config_value)])
}