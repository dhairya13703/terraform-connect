resource "aws_connect_instance" "POC" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  instance_alias           = local.connect_instance_alias
  outbound_calls_enabled   = true
  
  contact_flow_logs_enabled = true
  contact_lens_enabled      = true
  early_media_enabled       = true

}

resource "aws_connect_instance_storage_config" "S3" {
  instance_id   = aws_connect_instance.POC.id
  resource_type = "CALL_RECORDINGS"
  storage_config {
    storage_type = "S3"
    s3_config {
      bucket_name   = aws_s3_bucket.connect_resources.id
      bucket_prefix = "call-recordings/"
    }
  }
}

resource "aws_connect_instance_storage_config" "S3_CHAT_TRANSCRIPTS" {
  instance_id   = aws_connect_instance.POC.id
  resource_type = "CHAT_TRANSCRIPTS"

  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.connect_resources.id
      bucket_prefix = "call-transcripts/"
    }
    storage_type = "S3"
  }
}

resource "aws_connect_instance_storage_config" "KINESIS_STREAM" {
  resource_type = "CONTACT_TRACE_RECORDS"
  instance_id = aws_connect_instance.POC.id

  storage_config {
    storage_type = "KINESIS_STREAM"
    kinesis_stream_config {
      stream_arn = aws_kinesis_stream.connect_ctr_stream.arn
    }
  }
}

resource "aws_connect_instance_storage_config" "KINESIS_VIDEO_STREAM" {
  instance_id = aws_connect_instance.POC.id
  resource_type = "MEDIA_STREAMS"
  storage_config {
    storage_type = "KINESIS_VIDEO_STREAM"
    kinesis_video_stream_config {
      prefix                 = local.media_stream_prefix
      retention_period_hours = var.retention_period
      encryption_config {
        encryption_type = "KMS"
        key_id          = aws_kms_key.connect_key.arn
      }
    }
  }
}
