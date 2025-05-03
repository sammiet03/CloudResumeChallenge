## Importing an Existing Lambda Function into Terraform

### Overview
This guide outlines the process for importing an existing AWS Lambda function into Terraform, allowing you to manage it as code moving forward.


### Steps to Import Lambda

### 1. Create `lambda.tf`

Define the Lambda function resource:

```
resource "aws_lambda_function" "website_counter" {
  function_name = "WebsiteViewCounter"
  # Add additional configuration here (runtime, handler, role, etc.)
}
```

> **Tip:** Ensure that the associated IAM roles have permissions for **DynamoDB** and **API Gateway** if the Lambda interacts with these services.


### 2. Define Variables (Optional)

Create a `variables.tf` to manage reusable values such as:

```
variable "lambda_function_name" {}
variable "iam_role_arn" {}
```


### 3. Find Your Lambda Function ARN

Use the AWS CLI to retrieve the ARN:

```
aws lambda get-function --function-name WebsiteViewCounter
```

Take note of the `FunctionArn` from the output.



### 4. Initialize Terraform

```
terraform init
```


### 5. Import the Lambda Function

Use the ARN to import the Lambda into your Terraform state:

```
terraform import aws_lambda_function.website_counter arn:aws:lambda:<region>:<account_id>:function:WebsiteViewCounter
```

Replace `<region>` and `<account_id>` with your actual values.


### 6. Verify Imported Resource

List Terraform-managed resources:

```
terraform state list
```

You should see:

```
aws_lambda_function.website_counter
```



### 7. Plan and Review

Check the current configuration against the imported resource:

```
terraform plan
```


### 8. Apply Changes (If Needed)

If no unexpected changes appear in the plan, you can safely apply:

```
terraform apply
```

