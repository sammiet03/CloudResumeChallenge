resource "aws_dynamodb_table" "website_counter_table" {
  name         = "<your-dynamodb-table-name>"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name      = "<your-dynamodb-table-tag-name>"
    ManagedBy = "Terraform"
  }
}
