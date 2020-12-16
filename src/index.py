import json
import os

token=os.environ['token']
endpoint=os.environ['endpoint']

#def lambda_handler():
def lambda_handler(event, context):
    k1=event['key1']
    k2=event['key2']
    k3=event['key3']
    print(k1,k2,k3)
    print('run:\n')
#    print(token,endpoint)

    transactionResponse = {}
    transactionResponse['value1'] = k1
    transactionResponse['value2'] = k2
    transactionResponse['value3'] = k3
    transactionResponse['message'] = 'hello from tf-lambda'

    responseObject = {}
    responseObject['statusCode'] = 200
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    responseObject['body'] = json.dumps(transactionResponse)
   
    return responseObject
#    return {
#        'statusCode': 200,
#        'body': json.dumps('hello')
#    }
#print (lambda_handler())
