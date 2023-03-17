import json
import requests

def lambda_handler(event, context):
    url = "https://2xfhzfbt31.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data"
    headers = {"Content-Type":"application/json", "X-Siemens-Auth": "test"}
    payload = {
    "subnet_id": "subnet-01234567890abcdef",
    "name": "vinay patange",
    "email": "vinaydp78@gmail.com"
    } # replace with your request parameters
    response = requests.post(url, headers=headers, data=json.dumps(payload))
    return {
        "statusCode": response.status_code,
        "body": response.json()
    }
