## Importing Route 53 Resources into Terraform

### Overview
This guide explains how to safely import your existing Route 53 hosted zones and DNS records into Terraform without exposing sensitive information.



### Information Needed
- Hosted Zone ID (for your domain)
- Record Sets (A, AAAA, CNAME, etc.)



### Setup `providers.tf`
First, define your AWS provider configuration.

```
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
```

> **Note**: Use Terraform variables (`var.aws_access_key`, `var.aws_secret_key`) to securely manage your credentials.

After creating `providers.tf`, run the following:

```
terraform init     # Initialize the provider
terraform plan     # Verify the configuration
terraform import   # Begin importing existing resources
```



### Steps to Importing Route 53 Resources

### 1. Create `route53.tf`
Define your hosted zone:

```
resource "aws_route53_zone" "primary" {
  name = "yourdomain.com"
}
```

### 2. Locate Your Hosted Zone ID
Use the AWS CLI to find your Hosted Zone ID:

```
aws route53 list-hosted-zones
```


### 3. Define and Import Your DNS Records
Each DNS record (A, CNAME, etc.) must be explicitly defined and imported.

Example A record for the `www` subdomain:

```
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = "dXXXXXXXXXXXX.cloudfront.net" # CloudFront distribution domain (redacted)
    zone_id                = "Z2FDTNDATAQYW2"               # CloudFront hosted zone ID
    evaluate_target_health = false
  }
}
```


### Example Final `route53.tf`

```
resource "aws_route53_zone" "primary" {
  name = "example.com"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "example.com"
  type    = "A"

  alias {
    name                   = "dXXXXXXXXXXXX.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.example.com"
  type    = "A"

  alias {
    name                   = "dXXXXXXXXXXXX.cloudfront.net"
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
```


### Import Commands
Use the following to import existing resources:

```
terraform import aws_route53_zone.primary [Zone ID]
terraform import aws_route53_record.root ZONE_ID_yourdomain.com_A
terraform import aws_route53_record.www ZONE_ID_www.yourdomain.com_A
```

Replace placeholders (`[Zone ID]`, etc.) with your actual values.



### Validate the Imports
After importing, validate the configuration:

```
terraform plan
```

- Review the plan output to ensure Terraform correctly recognizes the imported resources.
