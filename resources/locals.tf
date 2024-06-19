locals {
  firehose_role_name      = "${var.base_name}-firehose-role"
  firehose_policy_name    = "${var.base_name}-firehose-policy"
  lambda_role_name        = "${var.base_name}-lambda-role"
  connect_instance_alias  = "${var.base_name}-connect-instance"
  s3_bucket_name          = "${var.base_name}-s3-connect-resources"
  kinesis_stream_name     = "${var.base_name}-ctr-stream"
  kms_key_description     = "KMS key for Amazon Connect"
  lambda_function_name    = "${var.base_name}-post-call-processing"
  media_stream_prefix     = "${var.base_name}-prefix"
  firehose_stream = "${var.base_name}-firehose-stream"
  lex_bot_name = "${var.base_name}_lex_bot" #Use underscore only
}  
