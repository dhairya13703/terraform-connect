# resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
#   name        = local.firehose_stream
#   destination = "extended_s3"

#   kinesis_source_configuration {
#     kinesis_stream_arn = aws_kinesis_stream.connect_ctr_stream.arn
#     role_arn           = aws_iam_role.firehose_role.arn
#   }

#   extended_s3_configuration {
#     role_arn   = aws_iam_role.firehose_role.arn
#     bucket_arn = aws_s3_bucket.firehose_stream_s3
#     prefix     = var.firehose_prefix
# }
