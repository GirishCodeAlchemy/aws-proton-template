module "lambda" {
  source = "git::https://github.com/GirishCodeAlchemy/terraform-lambda-module.git?ref=v1.0.0"

  count                 = length(local.service_inputs.lambda_map)
  resource_name_prefix  = local.resource_name_prefix
  lambda_name           = local.service_inputs.lambda_map[count.index].object_instance.lambda_name
  source_path           = "../lambda_code"
  vpc_id                = local.service_inputs.lambda_map[count.index].object_instance.vpc_id
  lambda_handler        = local.service_inputs.lambda_map[count.index].object_instance.lambda_handler
  lambda_description    = local.service_inputs.lambda_map[count.index].object_instance.lambda_description
  managed_policy_arns   = local.service_inputs.lambda_map[count.index].object_instance.managed_policy_arns_m
  lambda_inline_policy  = local.service_inputs.lambda_map[count.index].object_instance.lambda_inline_policy
  timeout               = local.service_inputs.lambda_map[count.index].object_instance.timeout
  memory_size           = local.service_inputs.lambda_map[count.index].object_instance.memory_size
  environment_variables = zipmap([for k in local.service_inputs.lambda_map[count.index].object_instance.environment_variables_map : k.name], [for v in local.service_inputs.lambda_map[count.index].object_instance.environment_variables_map : v.object_instance])
  aws_lambda_permission = local.service_inputs.lambda_map[count.index].object_instance.aws_lambda_permission
  schedule_time_trigger = local.service_inputs.lambda_map[count.index].object_instance.schedule_time_trigger
  event_pattern_trigger = local.service_inputs.lambda_map[count.index].object_instance.event_pattern_trigger
  log_retention_in_days = local.service_inputs.lambda_map[count.index].object_instance.log_retention_in_days

}

module "sqs" {
  source = "git::https://github.com/GirishCodeAlchemy/terraform-sqs-module.git//sqs?ref=v1.0.0"

  count                      = length(local.service_inputs.sqs_map)
  resource_name_prefix       = local.resource_name_prefix
  sqs_name                   = local.service_inputs.sqs_map[count.index].object_instance.sqs_name
  environment_variables      = zipmap([for k in local.service_inputs.sqs_map[count.index].object_instance.environment_variables_map : k.name], [for v in local.service_inputs.sqs_map[count.index].object_instance.environment_variables_map : v.object_instance])
  delay_seconds              = local.service_inputs.sqs_map[count.index].object_instance.delay_seconds
  max_message_size           = local.service_inputs.sqs_map[count.index].object_instance.max_message_size
  message_retention_seconds  = local.service_inputs.sqs_map[count.index].object_instance.message_retention_seconds
  receive_wait_time_seconds  = local.service_inputs.sqs_map[count.index].object_instance.receive_wait_time_seconds
  redrive_policy             = local.service_inputs.sqs_map[count.index].object_instance.redrive_policy
  visibility_timeout_seconds = local.service_inputs.sqs_map[count.index].object_instance.visibility_timeout_seconds
  environment                = local.environment
}

module "ec2" {
  source = "git::https://github.com/GirishCodeAlchemy/terraform-ec2-module.git?ref=v1.0.0"

  count                = length(local.service_inputs.ec2_map)
  resource_name_prefix = local.resource_name_prefix
  ami                  = local.service_inputs.ec2_map[count.index].object_instance.ami
  instance_type        = local.service_inputs.ec2_map[count.index].object_instance.instance_type
  key_name             = local.service_inputs.ec2_map[count.index].object_instance.key_name
  subnet_id            = local.service_inputs.ec2_map[count.index].object_instance.subnet_id
  vpc_id               = local.service_inputs.ec2_map[count.index].object_instance.vpc_id
  ec2_name             = local.service_inputs.ec2_map[count.index].object_instance.ec2_name
  program_tag          = local.service_inputs.ec2_map[count.index].object_instance.program_tag
  sg_rules             = local.service_inputs.ec2_map[count.index].object_instance.sg_rules
}

module "cloudwatch-trigger" {
  source = "git::https://github.com/GirishCodeAlchemy/terraform-cloudwatch-trigger-module.git?ref=v1.0.0"

  count                = length(local.service_inputs.cw-trigger_map)
  resource_name_prefix = local.resource_name_prefix
  rule_definition      = local.service_inputs.cw-trigger_map[count.index].object_instance.rule_definition
  sns_trigger          = local.service_inputs.cw-trigger_map[count.index].object_instance.sns_trigger
  lambda_trigger       = local.service_inputs.cw-trigger_map[count.index].object_instance.lambda_trigger
  log_group            = local.service_inputs.cw-trigger_map[count.index].object_instance.log_group
}

module "s3-bucket" {
  source = "git::https://github.eagleview.com/infrastructure/terraform-s3-module.git//s3?ref=v1.0.0"

  count                = length(local.service_inputs.s3_map)
  resource_name_prefix = local.resource_name_prefix
  s3_name              = local.service_inputs.s3_map[count.index].object_instance.s3_name
  acl                  = local.service_inputs.s3_map[count.index].object_instance.acl
  identifiers          = local.service_inputs.s3_map[count.index].object_instance.identifiers
  actions              = local.service_inputs.s3_map[count.index].object_instance.actions

}

module "iam" {
  source = "git::https://github.com/GirishCodeAlchemy/terraform-iam-module.git//iam?ref=v1.0.0"

  count                = length(local.service_inputs.iam_map)
  provisioned_by_tag   = local.service_inputs.iam_map[count.index].object_instance.provisioned_by_tag
  resource_name_prefix = local.resource_name_prefix
}

data "aws_caller_identity" "current" {}

output "assumed-identity-arn" {
  value = data.aws_caller_identity.current.arn
}