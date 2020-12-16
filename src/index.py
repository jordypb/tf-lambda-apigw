# This is a sample Python script.

import requests
import os
import json
from slugify import slugify

from queries import get_query_id_name, VARIANT_QUERY, UPDATE_VARIANT_STOCK_IMPROVED

token=os.environ['token']
endpoint=os.environ['endpoint']
 
def search_to_variables(search):
    return {
        "filter": {
            "search": search,
        }
    }


class ProductStockResource:
    def __init__(self, api_token, endpoint):
        self.headers = {"Authorization": "Bearer {}".format(api_token)}
        self.endpoint_url = endpoint

    def graphql_request(self, query, variables, headers, endpoint):
        """Execute the graphQL `query` provided on the `endpoint`.

        Parameters
        ----------
        query : str
            docstring representing a graphQL query.
        variables : dict, optional
            dictionary corresponding to the input(s) of the `query` must be
            serializable by requests into a JSON object.
        headers : dict, optional
            headers added to the request (important for authentication).
        endpoint : str, optional
            the graphQL endpoint url that will be queried, default is
            `GQL_DEFAULT_ENDPOINT`.

        Returns
        -------
        response : dict
            a dictionary corresponding to the parsed JSON graphQL response.

        Raises
        ------
        Exception
            when `response.status_code` is not 200.
        """
        response = requests.post(
            endpoint,
            headers=headers,
            json={
                'query': query,
                'variables': variables
            }
        )

        parsed_response = json.loads(response.text)
        if response.status_code != 200:
            raise Exception("{message}\n extensions: {extensions}".format(
                **parsed_response["errors"][0]))
        else:
            return parsed_response

    def graphql_execute(self, query, variables):
        return self.graphql_request(query, variables, self.headers, self.endpoint_url)

    def __get_id_from_name(self, query, name, type_name, unique_key='slug', return_node=False):
        variables = search_to_variables(name)
        response = self.graphql_execute(query, variables)
        total_count = response['data'][type_name]['totalCount']
        if total_count > 0:
            categories = response['data'][type_name]['edges']
            # return the first matched name of the data received
            match = list(filter(lambda a: a['node'][unique_key] == str(name), categories))
            if match:
                return match[0]['node'] if return_node else match[0]['node']['id']
        return ''

    def get_entity_id_by_key(self, name, entity, entity_in_plural, key):
        query = get_query_id_name(entity + 'FilterInput', entity_in_plural, key)
        response = self.__get_id_from_name(query, name, entity_in_plural, key)
        return response

    def get_warehouse_id(self, warehouse_name):
        warehouse_slug = slugify(warehouse_name)
        warehouse_id = self.get_entity_id_by_key(warehouse_slug, 'Warehouse',
                                                        'warehouses', 'slug')
        return warehouse_id

    def get_product_by_sku(self, sku_value, type_name='productVariants', key='slug'):
        query = VARIANT_QUERY
        product_id, variant_id = None, None
        # sku_value = graphene.Node.to_global_id('ProductVariant', sku_value)
        response = self.__get_id_from_name(query, sku_value, type_name, key, True)
        if response and 'product' in response:
            product_id, variant_id = response['product']['id'], response['id']

        return product_id, variant_id

    def update_stock(self, sku, warehouse, quantity):
        warehouse_id = self.get_warehouse_id(warehouse)
        if not warehouse_id:
            raise RuntimeError(f'Warehouse: {warehouse} not found')

        _, variant_id = self.get_product_by_sku(sku, 'productVariants', 'sku')
        if not variant_id:
            raise RuntimeError(f'Variant: {sku} not found')

        query = UPDATE_VARIANT_STOCK_IMPROVED
        variables = {
            "variantId": variant_id,
            "warehouse": warehouse_id,
            "quantity": quantity,
        }
        response = self.graphql_execute(query, variables)
        return response

def lambda_handler(event, context):
    sku=int(event["key1"])
    warehouse=event["key2"]
    quantity=int(event["key3"])
    print(sku,warehouse,quantity)
    print('run:\n')
#    print(token,endpoint)

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

    #productStockResource = ProductStockResource(token,endpoint)
    #response = productStockResource.update_stock(sku,warehouse,quantity)
    #print(response)
#print (lambda_handler())



#if __name__ == "__main__":
#    # resource = ProductStockResource(api_token='z6Dwb4JrQu9lLhEWClHwRtZAlUaXiI', endpoint='http://127.0.0.1:8000/graphql/')
#    # resource.update_stock('43226647', 'Americas', 50)
#    pass
