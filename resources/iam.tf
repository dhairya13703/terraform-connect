resource "aws_iam_role" "firehose_role" {
  name = local.firehose_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name      = local.firehose_role_name
    CreatedBy = "Terraform"
  }
}

resource "aws_iam_role_policy" "firehose_policy" {
  name = local.firehose_policy_name
  role = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        Resource = [
          aws_s3_bucket.firehose_stream_s3.arn,
          "${aws_s3_bucket.firehose_stream_s3.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        Resource = aws_kinesis_stream.connect_ctr_stream.arn
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = aws_kms_key.connect_key.arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:*:*:log-group:/aws/kinesisfirehose/*:log-stream:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = local.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name      = local.lambda_role_name
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "call_recordings_policy" {
  bucket = aws_s3_bucket.call_recordings.id
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
          "arn:aws:s3:::${aws_s3_bucket.call_recordings.id}",
          "arn:aws:s3:::${aws_s3_bucket.call_recordings.id}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "chat_transcripts_policy" {
  bucket = aws_s3_bucket.chat_transcripts.id
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
          "arn:aws:s3:::${aws_s3_bucket.chat_transcripts.id}",
          "arn:aws:s3:::${aws_s3_bucket.chat_transcripts.id}/*"
        ]
      }
    ]
  })
}

resource "aws_s3_bucket_policy" "scheduled_reports_policy" {
  bucket = aws_s3_bucket.scheduled_reports.id
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
          "arn:aws:s3:::${aws_s3_bucket.scheduled_reports.id}",
          "arn:aws:s3:::${aws_s3_bucket.scheduled_reports.id}/*"
        ]
      }
    ]
  })
}
