## Recommended Order for Terraform Conversion

This guide outlines the optimal sequence for importing and defining existing AWS resources into Terraform, ensuring minimal dependencies and smooth transitions.



### 1. Setup `providers.tf`
First, configure your AWS provider to define the region and credentials.

```
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
```

After creating `providers.tf`, initialize and plan:

```
terraform init     # Initializes the AWS provider
terraform plan     # Verifies the configuration
terraform import   # Imports existing AWS resources into Terraform state
```



### 2. Route 53
- Import Hosted Zones
- Import DNS Records
- Set up domain names (necessary for ACM and CloudFront later)



### 3. ACM (AWS Certificate Manager)
- Import SSL/TLS Certificates
- Ensure certificates are created in **us-east-1** (required for CloudFront)
- Use DNS validation, which requires Route 53 setup beforehand



### 4. S3 Bucket (Static Website Hosting)
- Import the S3 bucket
- Configure static website hosting settings
- Add/update bucket policies for public access or CloudFront usage



### 5. CloudFront Distribution
- Connect CloudFront distribution to the S3 origin
- Attach ACM certificate
- Reference Route 53 domain names (alternate domain names/CNAMEs)



### 6. Lambda (Visitor Counter Function)
- Import the Lambda function
- Import/define IAM roles and permissions
- Set environment variables as required



### 7. API Gateway
- Define API resources and methods
- Integrate API Gateway with the Lambda function
- Setup deployment stages (e.g., `prod`, `dev`)



### 8. DynamoDB
- Import DynamoDB tables
- Define key schema, attributes, and provisioned throughput



### 9. IAM Roles and Policies
- Import IAM roles and policies for Lambda and any additional services
- Ensure roles are mapped after the services they support are defined

