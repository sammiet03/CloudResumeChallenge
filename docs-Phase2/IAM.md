## Importing IAM Roles and Policies into Terraform

### Overview
This guide explains how to import existing AWS IAM roles and policies into Terraform, ensuring they are properly mapped to services like Lambda.

---

### Step-by-Step Instructions

### Step 1: Identify Existing IAM Roles and Policies

- **List IAM Roles:**

```
aws iam list-roles
```

- **List IAM Policies:**

```
aws iam list-policies --scope Local
```

(Local scope lists only customer-managed policies.)



### Step 2: Gather Required Details

For each role or policy you want to import, note:
- Role Name (e.g., `WebsiteLambdaExecutionRole`)
- Policy ARN (for managed policies)



### Step 3: Prepare Terraform Configuration

Create a new file, e.g., `iam.tf`.

### Example IAM Role:

```hcl
resource "aws_iam_role" "website_lambda_role" {
  name = "WebsiteLambdaExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    ManagedBy = "Terraform"
  }
}
```

### Example Inline Policy (Optional):

```
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "LambdaDynamoDBAccessPolicy"
  role = aws_iam_role.website_lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:us-east-1:123456789012:table/cloudresume"
      }
    ]
  })
}
```


### Step 4: Initialize Terraform

```
terraform init
```


### Step 5: Import the IAM Role

```
terraform import aws_iam_role.website_lambda_role WebsiteLambdaExecutionRole
```


### Step 6: Import the IAM Role Inline Policy

```
terraform import aws_iam_role_policy.lambda_dynamodb_policy WebsiteLambdaExecutionRole:LambdaDynamoDBAccessPolicy
```

> **Format:** `terraform import aws_iam_role_policy.<resource_name> <role_name>:<policy_name>`



### Step 7: Verify the Import

- List Terraform-managed resources:

```
terraform state list
```

- Inspect specific resources:

```
terraform state show aws_iam_role.website_lambda_role
terraform state show aws_iam_role_policy.lambda_dynamodb_policy
```


### Step 8: Plan and Apply

- Generate the Terraform plan:

```
terraform plan
```

- Apply the configuration if everything looks good:

```
terraform apply
```


### Summary of Commands

```
aws iam list-roles
aws iam list-policies --scope Local
terraform init
terraform import aws_iam_role.website_lambda_role WebsiteLambdaExecutionRole
terraform import aws_iam_role_policy.lambda_dynamodb_policy WebsiteLambdaExecutionRole:LambdaDynamoDBAccessPolicy
terraform state list
terraform plan
terraform apply
```

