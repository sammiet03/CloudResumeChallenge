# Data block to reference the existing ACM certificate
data "aws_acm_certificate" "cloudfront_cert" {
  domain      = var.domain_name
  statuses    = ["ISSUED"]
  most_recent = true
}

# Output the ARN to confirm the correct certificate is fetched
output "acm_certificate_arn" {
  value = data.aws_acm_certificate.cloudfront_cert.arn
}
