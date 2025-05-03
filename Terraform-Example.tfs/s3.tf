resource "aws_s3_bucket" "static_site" {
  bucket = "<your-s3-bucket-name>"

  tags = {
    Name      = "<your-s3-bucket-name>-static-site"
    ManagedBy = "Terraform"
  }
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    "Version": "2008-10-17",
    "Id": "PolicyForCloudFrontPrivateContent",
    "Statement": [
      {
        "Sid": "AllowCloudFrontServicePrincipal",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudfront.amazonaws.com"
        },
        "Action": "s3:GetObject",
        "Resource": "arn:aws:s3:::<your-s3-bucket-name>/*",
        "Condition": {
          "StringEquals": {
            "AWS:SourceArn": "arn:aws:cloudfront::<your-aws-account-id>:distribution/<your-cloudfront-distribution-id>"
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "static_site_cors" {
  bucket = aws_s3_bucket.static_site.id

  cors_rule {
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
