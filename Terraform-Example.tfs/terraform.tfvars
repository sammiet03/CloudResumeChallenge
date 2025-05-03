# AWS Region where your resources are hosted
aws_region = "us-east-1"

# Domain configuration for the website
domain_name = "<your-domain-name>"

# Alternative domain names for the CloudFront distribution (wildcard for subdomains)
subject_alternative_names = ["<your-domain-name>", "*.<your-domain-name>"]

# Hosted Zone ID in Route 53
route53_zone_id = "<your-route53-zone-id>"

# CloudFront specific domain configuration
alternate_domain_names = ["<your-domain-name>", "*.<your-domain-name>"]

# ACM Certificate ARN for enabling HTTPS
acm_certificate_arn = "<your-acm-certificate-arn>"

# S3 Bucket Domain Name (Origin for CloudFront)
origin_bucket_domain_name = "<your-origin-bucket-domain-name>"

# Optional path within the S3 bucket
origin_path = "/<your-origin-path>"

# Lambda@Edge Function ARN (for website counter or other edge functions)
lambda_arn = "<your-lambda-edge-function-arn>"

# Environment tag for resource management
environment = "production"

# API Gateway endpoint used by Lambda
api_gateway_endpoint = "<your-api-gateway-endpoint>"

# Existing IAM role name for Lambda execution
existing_iam_role_name = "<your-iam-role-name>"

# Existing DynamoDB table name
existing_dynamodb_table_name = "<your-dynamodb-table-name>"

# Existing API Gateway name
existing_api_gateway_name = "<your-api-gateway-name>"

# Existing API Gateway ID
existing_api_gateway_id = "<your-api-gateway-id>"
