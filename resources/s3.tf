resource "aws_s3_bucket" "call_recordings" {
  bucket = "${local.s3_bucket_name}-call-recordings"
  
  tags = {
    Name      = "${local.s3_bucket_name}-call-recordings"
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket" "chat_transcripts" {
  bucket = "${local.s3_bucket_name}-chat-transcripts"
  
  tags = {
    Name      = "${local.s3_bucket_name}-chat-transcripts"
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket" "scheduled_reports" {
  bucket = "${local.s3_bucket_name}-scheduled-reports"
  
  tags = {
    Name      = "${local.s3_bucket_name}-scheduled-reports"
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket" "firehose_stream_s3" {
  bucket = "${local.s3_bucket_name}-firehose-ctr-s3"
  
  tags = {
    Name      = "${local.s3_bucket_name}-scheduled-reports"
    CreatedBy = "Terraform"
  }
}
