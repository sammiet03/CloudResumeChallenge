## Setting Up a Custom Domain Using Route 53 and CloudFront

### Overview
This guide details how to point a custom domain name to your CloudFront distribution using Amazon Route 53. It also covers domain registration, DNS record configuration, SSL certificate setup, and troubleshooting.


### Purchasing a Domain in Route 53

1. Log in to the **AWS Management Console**.
2. Navigate to **Route 53**.
3. In the left menu, under **Domains**, click **Registered Domains** > **Register Domain**.
4. Search for your desired domain name, select it, and complete the purchase.
5. Domain registration may take from a few minutes to several hours.
6. Once you receive the confirmation email, proceed to configure the DNS records.



### Creating DNS Records

1. In the Route 53 console, navigate to **Hosted Zones**.
2. Select your newly registered domain.
3. Under the **Records** section, click **Create Record**.

You will create two A records:

### A Record (Root Domain)
- **Name**: *(leave blank)*
- **Record Type**: A
- **Alias**: Enabled
- **Route traffic to**: Alias to CloudFront distribution
- **Select your CloudFront distribution**

### CNAME Record (Subdomain www)
- **Name**: `www`
- **Record Type**: A (Alias)
- **Route traffic to**: Alias to CloudFront distribution


| Record Name       | Record Type | Routes Traffic To              | Reason                                                                 |
|-------------------|-------------|---------------------------------|-----------------------------------------------------------------------|
| domainname.com    | A           | Alias to CloudFront distribution | Points the root domain to CloudFront distribution                     |
| www.domainname.com | A           | Alias to CloudFront distribution | Points the www subdomain to CloudFront distribution                   |


### Configuring Your Custom Domain in CloudFront

1. Ensure your domain is registered and active in Route 53.
2. Navigate to **AWS Certificate Manager (ACM)**.
3. Click **Request a Certificate** > **Request a public certificate** > **Next**.
4. Add your domain names:
   - `rootdomain.com`
   - `*.rootdomain.com`
5. For **Validation Method**, choose **DNS validation**.
6. For **Key Algorithm**, leave **RSA 2048** selected.
7. Submit the request.
8. Add the required DNS validation records in Route 53.
9. After validation, navigate to **CloudFront**.
10. Click on your distribution and go to **General** > **Edit**.
11. Under **Alternate Domain Names (CNAMEs)**, add:
    - `rootdomain.com`
    - `*.rootdomain.com`
12. Under **Custom SSL certificate**, select the certificate you requested in ACM.
13. Save changes.



### Troubleshooting: Seeing a 403 Error

If you encounter a 403 Forbidden error when accessing your site:
- Confirm that your S3 bucket has the correct CORS policy applied.

Apply the following CORS configuration to your S3 bucket:

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


> **Tip**: After updating DNS settings, it may take a few minutes for changes to propagate globally.
