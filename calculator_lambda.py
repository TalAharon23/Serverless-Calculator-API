import json
import boto3

print('Loading function...')

def calculate_sum(num1, num2):
    return num1 + num2

def create_success_response(result):
    return {
        'statusCode': 200,
        'body': json.dumps({'result': result})
    }

def create_error_response(error, status_code):
    return {
        'statusCode': status_code,
        'body': json.dumps({'error': str(error)})
    }

def publish_to_sns(topic_arn, message):
    sns_client = boto3.client('sns')
    sns_client.publish(
        TopicArn=topic_arn,
        Message=message
    )

def handle_request(event):
    try:
        num1 = int(event['queryStringParameters']['num1'])
        num2 = int(event['queryStringParameters']['num2'])
        # num1 = int(event["num1"])
        # num2 = int(event["num2"])
        
        result = calculate_sum(num1, num2)
        result_message = f"Result: {num1} + {num2} = {result}"
        
        publish_to_sns('arn:aws:sns:us-east-1:133318666765:SubscriptionSNS', result_message)
        
        return create_success_response(result)
    
    except Exception as e:
        return create_error_response(e, 400)

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    return handle_request(event)
