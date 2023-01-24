data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  domain_name  = var.domain_name
  s3_origin_id = var.s3_origin_id
  env_tag      = var.environment_tag
  root_object  = var.root_object
  error_object = var.error_object
  price_class  = var.price_class
  www_dir      = var.www_dir
  cache_func   = var.default_cache_func_assoc
}

