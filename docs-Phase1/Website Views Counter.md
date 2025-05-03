## Creating a Website Views Counter

### Overview
Track how many users visit your website by creating a visitor counter that stores and updates the count in DynamoDB, using a Lambda function triggered by API Gateway.


### Step 1: Creating the DynamoDB Table

1. Log in to the **AWS Management Console**.
2. Navigate to **DynamoDB**.
3. Click **Tables** > **Create table**.
4. Set the table name.
5. Define the **Partition Key** as `id` of type **String**.
6. Click **Create Table**.
7. After creation, select the table, click **Actions** > **Explore items** > **Create item**.

Use the following item structure:

| Attribute Name | Value | Type   |
|----------------|-------|--------|
| id (Partition Key) | 1 | String |
| views          | 0     | Number |


### Step 2: Creating the Lambda Function (Python)

1. Navigate to the **Lambda** service in AWS.
2. Click **Create Function**.
3. Enter a function name.
4. Select **Python 3.13** as the runtime.
5. Leave **Create a new role with basic Lambda permissions** selected.
6. Click **Create Function**.

### Lambda Function Code

Replace `YOUR_TABLE_NAME` and `YOUR_ITEM_ID` appropriately.

```python
import json
import boto3
import logging
from decimal import Decimal

# Initialize DynamoDB resource
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('YOUR_TABLE_NAME')

# CORS Headers
cors_headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
}

def lambda_handler(event, context):
    try:
        response = table.update_item(
            Key={'id': 'YOUR_ITEM_ID'},
            UpdateExpression="SET #count = if_not_exists(#count, :start) + :inc",
            ExpressionAttributeNames={
                '#count': 'count'
            },
            ExpressionAttributeValues={
                ':start': 0,
                ':inc': 1
            },
            ReturnValues="UPDATED_NEW"
        )

        views = int(response['Attributes']['count'])

        return {
            'statusCode': 200,
            'headers': cors_headers,
            'body': json.dumps({'totalViews': views})
        }

    except Exception as e:
        logging.error(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': cors_headers,
            'body': json.dumps({'error': str(e)})
        }
```


### Benefits of Handling CORS Inside Lambda
- Automatically adds CORS headers on success **and** error responses.
- Simplifies API Gateway setup (no mapping templates needed).



### Step 2.1: Attach IAM Policy for Lambda Access to DynamoDB

Create and attach an inline policy to the Lambda execution role:

1. Navigate to **IAM**.
2. Go to **Roles** > Find your Lambda's role.
3. Click **Add Permissions** > **Create Inline Policy**.
4. Choose the **JSON** tab and add the following:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:GetItem",
                "dynamodb:PutItem",
                "dynamodb:UpdateItem"
            ],
            "Resource": "arn:aws:dynamodb:us-east-1:ACCOUNT_ID:table/TABLE_NAME"
        }
    ]
}
```

5. Name the policy `LambdaDynamoDBAccessPolicy` and attach it.


### Step 3: Create the API Gateway

- The frontend will make a **GET** request to the API Gateway URL.
- API Gateway triggers Lambda, which updates and returns the visitor count.


### Testing CORS with `curl`

To validate CORS configuration:

```bash
curl -i -X OPTIONS https://your-api-id.execute-api.us-east-1.amazonaws.com/[Stage]/[Resource] \
  -H "Origin: https://yourdomain.com" \
  -H "Access-Control-Request-Method: GET" \
  -H "Access-Control-Request-Headers: Content-Type"
```

### Expected Sample Output

```text
HTTP/2 200 
date: Wed, 26 Mar 2025 15:51:13 GMT
content-type: application/json
content-length: 0
x-amzn-requestid: [REDACTED]
access-control-allow-origin: *
access-control-allow-headers: Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token
access-control-allow-methods: GET,OPTIONS
```

---

### How It Works When a User Visits Your Website

1. **User visits** your site — static assets load from CloudFront.
2. **Frontend JavaScript** triggers a **GET** request to API Gateway.
3. **API Gateway** invokes the Lambda function.
4. **Lambda** updates the **view counter** in DynamoDB.
5. **Response** with updated view count is returned to the frontend.
6. **CORS** handled directly in Lambda for seamless frontend interaction.
