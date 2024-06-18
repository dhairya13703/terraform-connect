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


resource "aws_s3_bucket_policy" "connect_resources_bucket_policy" {
  for_each = toset(["call_recordings", "chat_transcripts", "scheduled_reports"])
  bucket   = aws_s3_bucket[each.key].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowFirehoseAccess"
        Effect    = "Allow"
        Principal = {
          AWS = aws_iam_role.firehose_role.arn
        }
        Action    = [
          "s3:GetBucketLocation",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetObject",
          "s3:PutObject",
          "s3:AbortMultipartUpload"  
        ]
        Resource = [
          aws_s3_bucket[each.key].arn,
          "${aws_s3_bucket[each.key].arn}/*"
        ]
      }
    ]
  })
}
