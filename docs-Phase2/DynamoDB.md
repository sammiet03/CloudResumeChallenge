## Moving an Existing DynamoDB Table to Terraform

### Overview
This guide details how to import an existing DynamoDB table into Terraform so it can be managed as infrastructure as code.


### Step 1: List Your DynamoDB Tables

Use the AWS CLI to find your table name:

```
aws dynamodb list-tables
```

---

### Step 2: Get Table Details

To verify your DynamoDB table's settings:

```
aws dynamodb describe-table --table-name <TableName>
```

Replace `<TableName>` with your actual table name (e.g., `cloudresume`).


### Step 3: Add the Resource Block in Terraform Configuration

Create or update your `dynamodb.tf` file:

```hcl
resource "aws_dynamodb_table" "website_counter_table" {
  name         = "cloudresume"   # Replace with your actual table name
  hash_key     = "id"            # Replace with your table's hash key
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name      = "Website Counter Table"
    ManagedBy = "Terraform"
  }
}
```

> **Note:** Ensure your hash key and attributes match your actual table schema.


### Step 4: Import the DynamoDB Table

Import the existing DynamoDB table into Terraform state:

```
terraform import aws_dynamodb_table.website_counter_table cloudresume
```


### Step 5: Verify the Import

List all imported Terraform resources:

```
terraform state list
```

You should see:

```
aws_dynamodb_table.website_counter_table
```

Inspect the imported resource for accuracy:

```
terraform state show aws_dynamodb_table.website_counter_table
```


### Step 6: Plan and Apply

Plan your Terraform changes to validate the configuration:

```
terraform plan
```

If everything looks good, apply the changes:

```
terraform apply
```


### Additional AWS Commands (Optional)

- **List Hosted Zones in Route 53** (for domain-related tasks):

```
aws route53 list-hosted-zones
```

- **Recheck DynamoDB Table Details:**

```
aws dynamodb describe-table --table-name cloudresume
```

