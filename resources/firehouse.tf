resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = local.firehouse_stream
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose_role.arn
    bucket_arn          = aws_s3_bucket.connect_resources.arn
    prefix              = var.firehose_prefix
    error_output_prefix = var.firehose_error_output_prefix
    kms_key_arn = aws_kms_key.connect_key.arn
  }

  tags = {
    Name      = local.firehouse_stream
    CreatedBy = "Terraform"
  }
}