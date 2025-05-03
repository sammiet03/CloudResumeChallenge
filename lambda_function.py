import json
import boto3
import os
import logging

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

cors_headers = {
    'Content-Type': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET,OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type'
}

def lambda_handler(event, context):
    if event['httpMethod'] == 'OPTIONS':
        return {
            'statusCode': 200,
            'headers': cors_headers,
            'body': json.dumps({'message': 'CORS preflight success'})
        }

    try:
        response = table.update_item(
            Key={'id': 'views'},
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
