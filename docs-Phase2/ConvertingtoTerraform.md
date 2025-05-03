# Phase 2 - Converting your AWS resources to IaC using Terraform 

### Steps 
1. Make sure you have Terraform installed on your computer 
2. Create a new project in Terraform using the commands below 
``` 
mkdir cloud-resume-challenge-terraform
cd cloud-resume-challenge-terraform
terraform init
```

3. Create a file named `main.tf` 
```
vi main.tf
```

4. Define AWS as the provider in your Terraform project 
```
provider "aws" {
  region = "us-east-1"  # Adjust to your desired AWS region
}
```

5. Import manually create resources on the AWS side to Terraform 
```
terraform innit
terraform import aws_s3_bucket.my_bucket my-bucket-name
``` 

6. Generate Terraform Configuration for the imported resources from AWS 
- Terraform doesn't automatically generate the corresponding `.tf` configuration files. So we will need to write them manually
- Defining resources, I will create a module for our Lambda function with an API Gateway 

```
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-bucket-name"
  acl    = "private"
}
```


7. Plan and Apply Terraform Code
``` 
terraform plan 
terraform apply
```

### Creating a module for Lambda function and API Gateway 
- If you're following best practices, you might want to create modules for reusability. For example, if you create a Lambda function with an API Gateway, package it in a module so it can be reused in other parts of your infrastructure.

1. Create a directory structure for the Terraform module 

`Directory Structure` 
```
cloud-resume-challenge-terraform/
│
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
    └── lambda_with_api_gateway/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
``` 

- modules/lambda_with_api_gateway/ will contain the module that you can reuse across different parts of your infrastructure.
- main.tf, variables.tf, and outputs.tf in the root of your project will reference the module and configure the overall infrastructure.

2. Define the Lambda Function and API Gateway in the Module 
- In `modules/lambda_with_api_gateway` directory, create the `main.tf` with the infrastructure you want to encapsulate into the module 

`modules/lambda_with_api_gateway/main.tf` 
```
resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime

  filename      = var.lambda_filename
  source_code_hash = filebase64sha256(var.lambda_filename)

  environment {
    variables = var.environment_variables
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = var.lambda_role_name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_gateway_name
  description = var.api_gateway_description
}

resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = var.api_resource_path
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
```

`modules/lambda_with_api_gateway/variables.tf` 
```
 variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
}

variable "lambda_filename" {
  description = "The path to the Lambda function deployment package"
  type        = string
}

variable "lambda_role_name" {
  description = "The name of the IAM role for Lambda function"
  type        = string
}

variable "environment_variables" {
  description = "A map of environment variables to set for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "api_gateway_description" {
  description = "A description of the API Gateway"
  type        = string
}

variable "api_resource_path" {
  description = "The resource path for the API"
  type        = string
}
```

`modules/lambda_with_api_gateway/outputs.tf`
```
output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.my_lambda.function_name
}

output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = "${aws_api_gateway_rest_api.api.invoke_url}/${aws_api_gateway_resource.api_resource.path_part}"
}
```

3. Using the Module with your Main Terraform Configuration 
- Now in your root you can use the module and pass values to it via the `main.tf` file 

`main.tf (Root)`
```
module "lambda_with_api_gateway" {
  source = "./modules/lambda_with_api_gateway"

  lambda_function_name = "my-lambda-function"
  lambda_handler       = "index.handler"
  lambda_runtime       = "nodejs14.x"
  lambda_filename      = "lambda.zip"  # path to your deployment package
  lambda_role_name     = "lambda-role"
  api_gateway_name     = "MyAPIGateway"
  api_gateway_description = "My API Gateway for Lambda"
  api_resource_path    = "myresource"
  environment_variables = {
    MY_ENV_VAR = "value"
  }
}

output "lambda_function_name" {
  value = module.lambda_with_api_gateway.lambda_function_name
}

output "api_gateway_url" {
  value = module.lambda_with_api_gateway.api_gateway_url
}
```

5. Deploy the Terraform module 
```
terraform init
terraform plan
terraform apply
```