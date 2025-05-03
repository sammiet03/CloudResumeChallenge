## Moving API Gateway to Terraform

### Overview
This guide provides detailed steps for importing an existing Amazon API Gateway configuration into Terraform, making your API fully managed as code.


### Steps to Import API Gateway Resources

### Step 1: Prepare Your Terraform Configuration

Create a new file (e.g., `api_gateway.tf`) and define your API Gateway structure.

#### Example `api_gateway.tf`

```
resource "aws_api_gateway_rest_api" "website_counter_api" {
  name        = "WebsiteCounterAPI"
  description = "API Gateway for the Website Counter Lambda function"
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.website_counter_api.id
  parent_id   = aws_api_gateway_rest_api.website_counter_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.website_counter_api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.website_counter_api.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.website_counter.invoke_arn
}

resource "aws_api_gateway_deployment" "website_counter" {
  depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.website_counter_api.id
  stage_name  = "prod"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.website_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.website_counter_api.id}/*"
}

data "aws_caller_identity" "current" {}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.website_counter.invoke_url
}
```


### Step 2: Import the Existing API Gateway

1. **List your APIs:**

```
aws apigateway get-rest-apis
```

Find your API ID.

2. **Import the Rest API:**

```
terraform import aws_api_gateway_rest_api.website_counter_api <api_id>
```

3. **Import Root Resource:**

```
terraform import aws_api_gateway_resource.root <api_id>/<root_resource_id>
```

4. **Import Views Resource (Optional if you have additional resources):**

```
terraform import aws_api_gateway_resource.views <api_id>/<views_resource_id>
```

5. **Import Methods:**

```
terraform import aws_api_gateway_method.proxy <api_id>/<resource_id>/GET
terraform import aws_api_gateway_method.proxy_options <api_id>/<resource_id>/OPTIONS
```

6. **Import Integration:**

```
terraform import aws_api_gateway_integration.lambda <api_id>/<resource_id>/GET
```

7. **Import Deployment:**

```
terraform import aws_api_gateway_deployment.website_counter <api_id>/<deployment_id>
```

8. **Import Lambda Permission:**

```
terraform import aws_lambda_permission.apigw <lambda_function_name>/<statement_id>
```

> **Replace placeholders**:
> - `<api_id>`: API Gateway ID
> - `<root_resource_id>`: Root resource ID
> - `<views_resource_id>`: Views resource ID
> - `<deployment_id>`: Deployment ID
> - `<lambda_function_name>`: Your Lambda function name
> - `<statement_id>`: Lambda permission statement ID


### Step 3: Verify Imported Resources

List resources managed by Terraform:

```
terraform state list
```

Inspect specific resources:

```
terraform state show aws_api_gateway_rest_api.website_counter_api
```



### Step 4: Plan and Apply

Plan to verify no drift:

```
terraform plan
```

Apply changes if needed:

```
terraform apply
```



### Summary of Key Commands

```
terraform init
terraform import aws_api_gateway_rest_api.website_counter_api <api_id>
terraform import aws_api_gateway_resource.root <api_id>/<root_resource_id>
terraform import aws_api_gateway_resource.views <api_id>/<views_resource_id>
terraform import aws_api_gateway_method.proxy <api_id>/<views_resource_id>/GET
terraform import aws_api_gateway_method.proxy_options <api_id>/<views_resource_id>/OPTIONS
terraform import aws_api_gateway_integration.lambda <api_id>/<views_resource_id>/GET
terraform import aws_api_gateway_deployment.website_counter <api_id>/<deployment_id>
terraform import aws_lambda_permission.apigw <lambda_function_name>/<statement_id>
terraform state list
terraform plan
terraform apply
```