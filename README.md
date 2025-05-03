## ☁️ Cloud Resume Challenge with AWS - Phase 2 with Terraform

### Overview

The **Cloud Resume Challenge** is a hands-on project designed to demonstrate cloud computing skills by building and deploying a personal resume website using AWS services. This project integrates cloud technologies, automation, and Infrastructure as Code (IaC) to create a fully functional and scalable cloud-based application.

In this version of the project, we will initially start by **manually provisioning** the required AWS resources, and later, we will transition to **managing everything with Terraform**. By completing this challenge, you'll learn to leverage AWS services, serverless technologies, and best practices in security and automation.

### 📁 Project Features
- **Static Website Hosting** – The resume is built using HTML, CSS, and JavaScript and is hosted on Amazon S3 as a static website.
- **Content Delivery Network (CDN)** – Amazon CloudFront is used to enhance performance and security.
- **Custom Domain & HTTPS** – Configured with Amazon Route 53 and secured using AWS Certificate Manager (ACM).
- **Visitor Counter with DynamoDB** – A serverless visitor tracking system is implemented using AWS DynamoDB.
- **API with AWS Lambda & API Gateway** – A Python-based AWS Lambda function updates the visitor count and is exposed through Amazon API Gateway.
- **Infrastructure as Code (IaC)** – All AWS resources are provisioned using Terraform (after manual provisioning in the initial phase).
- **CI/CD Pipeline** – GitHub Actions automates deployments, ensuring a streamlined workflow.
- **Security Best Practices** – IAM roles and policies are configured to follow the principle of least privilege.

### 🚀 Tech Stack
- **Frontend**: HTML, CSS, JavaScript
- **Backend**: AWS Lambda (Python), DynamoDB
- **Infrastructure as Code**: Terraform
- **CI/CD**: GitHub Actions
- **Cloud Services**: AWS S3, CloudFront, Route 53, DynamoDB, Lambda, API Gateway

### 🧱 Architecture

The project uses several AWS services to create a full cloud-based resume website:

1. **S3** for hosting the static website.
2. **CloudFront** to serve the website with better performance and security.
3. **Route 53** to manage the custom domain (e.g., `www.yourdomain.com`).
4. **DynamoDB** to track the number of visitors to the website.
5. **Lambda** to handle the visitor counter logic.
6. **API Gateway** to expose the Lambda function via a REST API.
7. **IAM Roles** for securing AWS resources using the principle of least privilege.


<p align="center">
  <img src="https://github.com/sammiet03/CloudResumeChallenge/blob/main/Images/cloud-resume-diagram.png" alt="Architecture Diagram" width="600"/>
</p>



### 🛠️ Project Setup

### Phase 1: Manual Provisioning of AWS Resources

In the first phase of this project, we will manually provision all the required AWS resources through the **AWS Management Console**. This will help us better understand how each service is configured and integrated.

Here are the key resources we will manually provision in this phase:
- **S3 Bucket** for static website hosting.
- **CloudFront** distribution for serving the website.
- **Route 53** for setting up a custom domain and DNS records.
- **DynamoDB** for tracking visitor count.
- **Lambda** function for the visitor counter logic.
- **API Gateway** to trigger the Lambda function.
- **SSL certificate** using AWS Certificate Manager (ACM) for HTTPS.

Refer to the detailed guides in the `docs-Phase1` folder for instructions on manually provisioning each service.

### Phase 2: Transition to Terraform (IaC)

Once we've manually provisioned and verified the resources in AWS, we will move on to the second phase, where we will convert the manually provisioned infrastructure into **Terraform configuration files**.

In this phase, we will:
- Write Terraform configuration files for each AWS service (S3, CloudFront, Route 53, etc.).
- Use **Terraform** to automate the creation, modification, and destruction of these resources.
- Transition from manual management to Infrastructure as Code (IaC), ensuring that future updates and deployments are automated and version-controlled.

After completing the Terraform configuration, you will be able to apply and manage the entire infrastructure using Terraform, making it easier to maintain and scale the application over time.

### 🔰 Getting Started

Follow these steps to set up the project:

### 1. Phase 1: Manually Provision AWS Resources

In this phase, you will manually create the following resources through the AWS Management Console:
- S3 bucket for hosting the static resume website.
- CloudFront distribution to serve the website.
- Route 53 to configure your custom domain.
- DynamoDB for tracking the visitor count.
- Lambda for the visitor counter logic.
- API Gateway to trigger the Lambda function.
- SSL certificate using ACM for HTTPS.

Refer to the detailed guides in the `docs-Phase1` folder for instructions on manually provisioning each service.

### 2. Verify the Manual Setup

After manually provisioning the resources, verify that everything is working as expected:
- Access your resume website through the S3 bucket URL or your custom domain.
- Test that the visitor count is updating in DynamoDB as you refresh the page.
- Ensure the website is being served securely via HTTPS using CloudFront.

### 3. Phase 2: Transition to Terraform

Once you have verified that everything works manually, follow the instructions in the `docs-Phase2` folder to convert the manually provisioned resources to Terraform configuration.

- **Initialize Terraform**:

```
terraform init
```

- **Apply the Terraform Configuration**:

```
terraform apply
```

Terraform will prompt you to confirm the creation of resources. Type `yes` to proceed. This will automatically provision the same resources (S3, CloudFront, Route 53, etc.) via Terraform.

### 4. Access the Website

Once the Terraform configuration is applied, Terraform will output the URL for your website and the API endpoint for the visitor counter. You can access your resume website at:

- **Website URL**: `http://your-bucket-name.s3-website-us-east-1.amazonaws.com`
- **Custom Domain URL**: `https://www.yourdomain.com` (if configured with Route 53)

### 5. Verify the Visitor Counter

The visitor counter is updated automatically via the API exposed by API Gateway and Lambda. Every time the website is accessed, the count will increment in DynamoDB.

### 6. Clean Up Resources (Optional)

If you no longer need the resources, you can destroy them using Terraform:

```
terraform destroy
```

This will remove all resources created by Terraform (S3, CloudFront, Route 53, etc.) to avoid unnecessary costs.

### 📝 Documentation

Each resource is documented in the `docs-Phase1` and `docs-Phase2` folders. These guides provide step-by-step instructions on how to configure each AWS service manually and then using Terraform:

- **APIGatewayandLambda.md**: Set up API Gateway and Lambda for the visitor counter.
- **CloudFront.md**: Configure CloudFront for CDN.
- **ConvertingtoTerraform.md**: Convert manually provisioned resources to Terraform.
- **CustomDomainandRoute53.md**: Configure Route 53 for a custom domain.
- **DynamoDB.md**: Set up DynamoDB for visitor tracking.
- **S3Bucket.md**: Set up an S3 bucket for static website hosting.

### 🎯 Learning Outcomes

By completing this project, I gained hands-on experience with:

- **AWS Services**: S3, CloudFront, Route 53, DynamoDB, Lambda, API Gateway
- **Serverless Computing**: Using Lambda and DynamoDB to build scalable applications.
- **Infrastructure as Code (IaC)**: Using Terraform to manage cloud resources.
- **CI/CD Pipelines**: Automating the deployment process with GitHub Actions (optional).
- **Cloud Security**: Implementing security best practices in IAM roles and policies.


### 🧠 Conclusion

This project is a comprehensive example of how to leverage AWS services and Terraform to build and deploy a scalable personal website, while also learning cloud technologies like serverless computing, CDN, and database tracking. 

You will first provision the resources manually to understand the services involved, and then transition to using Terraform for automation and management, ensuring that future deployments are repeatable and easily managed.
