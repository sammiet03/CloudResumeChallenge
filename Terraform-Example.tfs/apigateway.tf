# Create the API Gateway REST API
resource "aws_api_gateway_rest_api" "website_counter_api" {
  name        = "<your-api-gateway-name>"
  description = "API Gateway for the Website Counter Lambda function"
}

# Get the root ("/") resource
data "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.website_counter_api.id
  path        = "/"
}

# Create the "/views" subresource
resource "aws_api_gateway_resource" "views" {
  rest_api_id = aws_api_gateway_rest_api.website_counter_api.id
  parent_id   = data.aws_api_gateway_resource.root.id
  path_part   = "views"
}

# Define the GET method for /views
resource "aws_api_gateway_method" "get_views" {
  rest_api_id   = aws_api_gateway_rest_api.website_counter_api.id
  resource_id   = aws_api_gateway_resource.views.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrate the GET method with Lambda
resource "aws_api_gateway_integration" "lambda_get_views" {
  rest_api_id             = aws_api_gateway_rest_api.website_counter_api.id
  resource_id             = aws_api_gateway_resource.views.id
  http_method             = aws_api_gateway_method.get_views.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.website_counter.invoke_arn
}

# Deploy the API (without stage_name)
resource "aws_api_gateway_deployment" "website_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.website_counter_api.id

  depends_on = [
    aws_api_gateway_integration.lambda_get_views
  ]
}

# Attach a stage to the deployment (recommended)
resource "aws_api_gateway_stage" "prod" {
  rest_api_id    = aws_api_gateway_rest_api.website_counter_api.id
  deployment_id  = aws_api_gateway_deployment.website_api_deployment.id
  stage_name     = "prod"
  description    = "Production stage"
}

# Lambda permission to allow API Gateway invocation
resource "aws_lambda_permission" "apigw_invoke_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.website_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.website_counter_api.execution_arn}/*/*"
}
