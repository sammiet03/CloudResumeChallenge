# Data block to reference the existing IAM role
data "aws_iam_role" "lambda_exec" {
  name = "<your-lambda-execution-role-name>"
}

# Data block to reference the existing DynamoDB table
data "aws_dynamodb_table" "website_counter_table" {
  name = var.existing_dynamodb_table_name
}

# Lambda function (managed by Terraform)
resource "aws_lambda_function" "website_counter" {
  function_name    = "<your-lambda-function-name>"
  role             = data.aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.13"
  filename         = "${path.module}/website_counter.zip"
  source_code_hash = filebase64sha256("${path.module}/website_counter.zip")

  publish = true

  environment {
    variables = {
      DYNAMODB_TABLE = var.existing_dynamodb_table_name
      API_GATEWAY    = var.api_gateway_endpoint
      ENVIRONMENT    = var.environment
    }
  }

  tags = {
    Name      = "<your-lambda-function-tag-name>"
    ManagedBy = "Terraform"
  }
}

# Lambda alias pointing to the published version
resource "aws_lambda_alias" "website_counter" {
  name             = "live"
  function_name    = aws_lambda_function.website_counter.function_name
  function_version = aws_lambda_function.website_counter.version
}

# Local variable to store the exact version ARN
locals {
  lambda_exact_version_arn = "arn:aws:lambda:${var.aws_region}:${data.aws_caller_identity.current.account_id}:function:${aws_lambda_function.website_counter.function_name}:${aws_lambda_function.website_counter.version}"
}
