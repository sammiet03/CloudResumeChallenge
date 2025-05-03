# variables.tf

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "domain_name" {
  description = "The primary domain name for the certificate and CloudFront distribution"
  type        = string
}

variable "subject_alternative_names" {
  description = "Alternative domain names for the certificate"
  type        = list(string)
  default     = ["<your-domain-name>", "*.<your-domain-name>"]
}

variable "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  type        = string
}

variable "alternate_domain_names" {
  description = "Alternative domain names for CloudFront distribution"
  type        = list(string)
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for SSL"
  type        = string
}

variable "origin_bucket_domain_name" {
  description = "The S3 bucket domain name used as the origin"
  type        = string
}

variable "origin_path" {
  description = "The origin path in the S3 bucket"
  type        = string
  default     = "/<your-origin-path>"
}

variable "environment" {
  description = "Deployment environment (e.g., production, staging)"
  type        = string
  default     = "production"
}

variable "existing_dynamodb_table_name" {
  description = "Name of the existing DynamoDB table used by the Lambda function"
  type        = string
}

variable "api_gateway_endpoint" {
  description = "The URL of the deployed API Gateway for the Lambda function"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda@Edge function"
  type        = string
}

variable "existing_iam_role_name" {
  description = "Name of the existing IAM role used by Lambda"
  type        = string
}

variable "existing_api_gateway_id" {
  description = "ID of the existing API Gateway"
  type        = string
}

variable "existing_api_gateway_name" {
  description = "Name of the existing API Gateway"
  type        = string
}
