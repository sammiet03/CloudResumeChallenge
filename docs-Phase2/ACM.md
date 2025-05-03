## Importing ACM Certificates into Terraform

### Overview
This guide covers how to import an existing ACM (AWS Certificate Manager) certificate into Terraform, including optional DNS validation automation using Route 53.

> **Important:** Your certificate must be created in the **`us-east-1`** region for CloudFront compatibility.


### Steps to Import ACM Certificate

### 1. Create `acm.tf`

Define your ACM resource:

```
resource "aws_acm_certificate" "cloudfront_cert" {
  domain_name       = "example.com"
  validation_method = "DNS"

  subject_alternative_names = [
    "www.example.com"
  ]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    ManagedBy = "Terraform"
  }
}
```



### 2. (Optional) Automate DNS Validation with Route 53

To automate validation for the certificate using Terraform:

```
resource "aws_route53_record" "acm_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cloudfront_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}
```

> **Note:** ACM will only request a single DNS validation record (e.g., `_acme-challenge.example.com`), not separate records for each SAN.


### 3. Initialize Terraform

After creating `acm.tf`, initialize your working directory:

```
terraform init
```

---

### 4. Import the Existing ACM Certificate

List available certificates using the AWS CLI:

```
aws acm list-certificates --region us-east-1
```

Locate the correct certificate ARN, then import it:

```
terraform import aws_acm_certificate.cloudfront_cert arn:aws:acm:us-east-1:123456789012:certificate/abcdefg-1234-5678-abcd-123456abcdef
```

---

### 5. Verify with Terraform Plan

Run `terraform plan` to confirm that the imported state matches your Terraform configuration:

```
terraform plan
```

- Review any differences carefully and update your `.tf` files if necessary.

