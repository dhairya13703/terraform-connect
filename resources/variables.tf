variable "region" {
  default = "eu-west-2"
}

variable "base_name" {
  description = "Base name for resources"
  default     = "poc"
}

variable "shard_count" {
  description = "Number of shards for Kinesis stream"
  default     = 1
}

variable "retention_period" {
  description = "Retention period for Kinesis stream (in hours)"
  default     = 24
}

variable "lambda_runtime" {
  description = "Runtime for Lambda function"
  default     = "nodejs18.x"
}

variable "s3_call_recording_prefix" {
  description = "S3 call recording prefix value"
  default = "call-recordings/"
}

variable "s3_chat_transcripts_prefix" {
  description = "S3 chat transcripts prefix value"
  default = "call-transcripts/"
}

variable "s3_scheduled_reports_prefix" {
  description = "S3 chat transcripts prefix value"
  default = "scheduled_reports/"
}

variable "firehose_prefix" {
  description = "Prefix for the Firehose delivery stream"
  default     = "ctr/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
}

variable "firehose_error_output_prefix" {
  description = "Error output prefix for the Firehose delivery stream"
  default     = "ctr-errors/!{firehose:error-output-type}/year=!{timestamp:yyyy}/month=!{timestamp:MM}/day=!{timestamp:dd}/"
}