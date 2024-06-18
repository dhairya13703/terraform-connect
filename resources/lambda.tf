resource "aws_lambda_function" "post_call_processing" {
  filename      = "lambda-function.zip"
  function_name = local.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = var.lambda_runtime

  tags = {
    Name      = local.lambda_function_name
    CreatedBy = "Terraform"
  }
}