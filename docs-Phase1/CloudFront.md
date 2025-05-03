## Configuring CloudFront for Secure Content Distribution

### Overview
This guide explains how to configure Amazon CloudFront to distribute content from an S3 bucket without making the bucket publicly accessible.


### Steps to Configure CloudFront

1. Log in to the **AWS Management Console** and navigate to **CloudFront**.
2. Click **Create Distribution**.
3. For **Origin Domain**, select the S3 bucket created earlier.
4. For **Origin Access**, choose **Origin access control settings**:
   - This grants CloudFront permission to read objects from your private S3 bucket.
5. Under **Viewer Protocol Policy**, select **HTTPS Only**.
6. Click **Create Distribution**.
7. After creation, open your CloudFront distribution.
8. Go to **Settings** > **Edit**.
9. Set **Default Root Object** to `index.html`.
10. Copy the **CloudFront Origin Access Policy** details.
11. Navigate back to your S3 bucket:
    - Go to **Permissions** > **Bucket Policy** > **Edit**.
    - Add the policy you copied from CloudFront.
12. Return to CloudFront, open your distribution, and verify that under **Settings**:
    - **Alternate Domain Names (CNAMEs)** includes `rootdomain.com` and `www.rootdomain.com`.



### S3 Bucket Policy for CloudFront Access

Replace `examplebucket`, `youAWSAccountID`, and `YourCloudFrontDistributionID` with your specific details:

```
{
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
            "Resource": "arn:aws:s3:::examplebucket/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::youAWSAccountID:distribution/YourCloudFrontDistributionID"
                }
            }
        }
    ]
}
```

### Important Notes

- If your `index.html` and assets are inside a folder within the S3 bucket (e.g., `/cloudresumechallenge`):
  - Set an **Origin Path** in CloudFront, e.g., `/cloudresumechallenge`.
  - Update your asset URLs in `index.html` to reference the CloudFront domain.

Example asset references:

```
<link href="https://[cloudfrontdomainname].cloudfront.net/css/bootstrap.min.css" rel="stylesheet">
<img src="https://[cloudfrontdomainname].cloudfront.net/images/illustrations/website-app.svg" alt="hello"/>
```


### Understanding CORS (Cross-Origin Resource Sharing)

- **CORS** is a **browser security feature** that controls how resources are shared across different domains.
- It only applies to web browsers.
- If a website tries to fetch resources from another domain (e.g., CloudFront to S3), CORS settings must allow it.

### CORS Policy for S3 Bucket
Apply the following configuration to your S3 bucket:

```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": []
    }
]
```