resource "aws_kinesis_stream" "connect_ctr_stream" {
  name             = local.kinesis_stream_name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  tags = {
    Name      = local.kinesis_stream_name
    CreatedBy = "Terraform" 
  }
}