## Creating an S3 bucket for Static Website Hosting

### Overview
This guide provides step-by-step instructions to configure an Amazon S3 bucket for hosting a static website, including setting the required bucket policies and CORS configuration.


### Prerequisites
- An active AWS account
- A folder containing your `index.html` and any necessary assets (e.g., images)


### Creating the S3 Bucket

1. Sign in to the **AWS Management Console**.
2. In the search bar, type **S3** and select the service.
3. Ensure you are in the AWS Region closest to your users.
4. In the S3 console, click **Create bucket**.
5. Configure the bucket:
   - **Bucket name**: Must be **globally unique**.
   - **Block Public Access settings**: Leave "Block all public access" **enabled**.
   - **ACLs**: Keep **disabled**.
6. Scroll to the bottom and click **Create bucket**.
7. After creation, upload your project folder containing the `index.html` file and related assets.



### Configuring the Bucket Policy for CloudFront

If you are serving the website through Amazon CloudFront, apply the following bucket policy.

Replace `<bucket-name>`, `<account-id>`, and `<distribution-id>` with your values:

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
            "Resource": "arn:aws:s3:::<bucket-name>/*",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "arn:aws:cloudfront::<account-id>:distribution/<distribution-id>"
                }
            }
        }
    ]
}
```

### Setting a CORS Policy for the S3 Bucket

To allow cross-origin resource sharing (CORS):

1. Open the **S3 console**.
2. Select your bucket.
3. Navigate to the **Permissions** tab.
4. Scroll to **Cross-origin resource sharing (CORS)** and click **Edit**.
5. Replace the configuration with the following:

```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "HEAD"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": [
            "ETag"
        ],
        "MaxAgeSeconds": 3000
    }
]
```



### Notes
- Make sure your `index.html` file is correctly named and uploaded to the root of your bucket.

