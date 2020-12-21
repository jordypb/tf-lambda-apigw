import json

from product_stock_resource import ProductStockResource
import os


def stocks_handler(event, context):
    try:
        message_body = json.loads(event['body'])
        quantity = message_body['quantity']
        sku = message_body['sku']
        warehouse = message_body['warehouse']
        api_token = os.environ.get("API_TOKEN") or ""
        graphql_endpoint = os.environ.get("GRAPHQL_ENDPOINT") or ""

        resource = ProductStockResource(api_token=api_token,
                                        endpoint=graphql_endpoint)
        resource.update_stock(sku, warehouse, quantity)

        response = {
            "statusCode": 201,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({"message": "Product Stock created successfully"})
        }

    except RuntimeError as exception:

        response = {
            "statusCode": 500,
            "headers": {
                "Content-Type": "application/json"
            },
            "body": json.dumps({"message": str(exception)})
        }

    return response
