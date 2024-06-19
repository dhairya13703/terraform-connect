resource "aws_connect_instance" "POC" {
  identity_management_type = "CONNECT_MANAGED"
  inbound_calls_enabled    = true
  instance_alias           = local.connect_instance_alias
  outbound_calls_enabled   = true
  
  contact_flow_logs_enabled = true
  contact_lens_enabled      = true
  early_media_enabled       = true
}

resource "aws_connect_instance_storage_config" "s3_call_recording" {
  instance_id   = aws_connect_instance.POC.id
  resource_type = "CALL_RECORDINGS"
  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.call_recordings.id
      bucket_prefix = "call-recordings/"
      encryption_config {
        encryption_type = "KMS"
        key_id          = aws_kms_key.connect_key.arn
      }
    }
    storage_type = "S3"
  }
}

resource "aws_connect_instance_storage_config" "s3_chat_transcripts" {
  instance_id   = aws_connect_instance.POC.id
  resource_type = "CHAT_TRANSCRIPTS"

  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.chat_transcripts.id
      bucket_prefix = var.s3_chat_transcripts_prefix
      encryption_config {
        encryption_type = "KMS"
        key_id          = aws_kms_key.connect_key.arn
      }
    }
    storage_type = "S3"
  }
}

resource "aws_connect_instance_storage_config" "s3_scheduled_reports" {
  instance_id   = aws_connect_instance.POC.id
  resource_type = "SCHEDULED_REPORTS"

  storage_config {
    s3_config {
      bucket_name   = aws_s3_bucket.scheduled_reports.id
      bucket_prefix = var.s3_scheduled_reports_prefix
      encryption_config {
        encryption_type = "KMS"
        key_id          = aws_kms_key.connect_key.arn
      }
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
