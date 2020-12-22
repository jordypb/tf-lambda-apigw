# This is a sample Python script.

import requests
import os
import json

token=os.environ['token']
endpoint=os.environ['endpoint']
 
def lambda_handler(event, context):
    sku=int(event["key1"])
    warehouse=event["key2"]
    quantity=int(event["key3"])
    print(sku,warehouse,quantity)
    print('run:\n')
    print(token,endpoint)

    transactionResponse = {}
    transactionResponse['value1'] = sku
    transactionResponse['value2'] = warehouse
    transactionResponse['value3'] = quantity
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
    #productStockResource = ProductStockResource(token,endpoint)
    #response = productStockResource.update_stock(sku,warehouse,quantity)
    #print(response)
#print (lambda_handler())



#if __name__ == "__main__":
#    # resource = ProductStockResource(api_token='hbhXiI', endpoint='http://127.0.0.1:8000/graphql/')
#    # resource.update_stock('43226647', 'Americas', 50)
#    pass
