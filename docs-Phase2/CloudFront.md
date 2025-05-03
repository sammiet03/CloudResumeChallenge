## Converting an Existing CloudFront Distribution to Terraform

### Overview
This guide walks through the process of importing an existing Amazon CloudFront distribution into Terraform management.



### Steps to Import CloudFront Distribution

### 1. Gather Required Information

Before starting, collect the following details from your CloudFront distribution:
- **Distribution ID**
- **Origin Domain Name** (e.g., S3 bucket URL)
- **Alternate Domain Names** (CNAMEs)
- **SSL Certificate ARN**
- **Behavior Settings** (e.g., caching policies)
- **Lambda@Edge Configuration** (if applicable)
- **Custom Error Pages**
- **Logging Settings**

### Command to Retrieve Current Configuration

```
aws cloudfront get-distribution --id <DISTRIBUTION_ID>
```

---

### 2. Create `cloudfront.tf`

Define your CloudFront distribution resource in Terraform based on the information collected.

```
resource "aws_cloudfront_distribution" "website_distribution" {
  # Configuration details go here (origin, behaviors, aliases, certificate, etc.)
}
```

> **Tip:** Start minimal and iterate — especially for complex distributions.


### 3. Initialize Terraform

```
terraform init
```


### 4. Import the Existing CloudFront Distribution

Use the following command to import the distribution into Terraform state:

```
terraform import aws_cloudfront_distribution.website_distribution [CLOUDFRONT_DISTRIBUTION_ID]
```

Replace `[CLOUDFRONT_DISTRIBUTION_ID]` with your actual distribution ID.


### 5. Verify the Import

Run a plan to review the current state and configuration:

```
terraform plan
```


### 6. Manage CloudFront with Terraform

Once imported, you can manage your CloudFront distribution via Terraform:

```
terraform apply
terraform output
```

List all resources currently managed by Terraform:

```
terraform state list
```

