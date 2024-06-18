resource "aws_s3_bucket" "connect_resources" {
  bucket = local.s3_bucket_name
  
  tags = {
    Name      = local.s3_bucket_name
    CreatedBy = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "connect_resources_bucket_policy" {
    bucket = aws_s3_bucket.connect_resources.id

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
          aws_s3_bucket.connect_resources.arn,
          "${aws_s3_bucket.connect_resources.arn}/*"
        ]
      }
    ]
  })
}