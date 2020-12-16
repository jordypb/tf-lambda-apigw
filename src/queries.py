def get_query_id_name(filter_type, type_name, unique_key, limit=100):
    return f"""
        query ($filter: {filter_type}!, ) {{
            {type_name}(first:{limit}, filter: $filter) {{
                totalCount
                edges {{
                    node {{
                        id
                        name
                        {unique_key}
                    }}
                }}
            }}
        }}
    """


VARIANT_QUERY = """
        query ($filter: ProductVariantFilterInput!) {
            productVariants (first:100, filter: $filter) {
                totalCount
                edges {
                    node {
                        id
                        sku
                        product {
                            id
                            name
                            slug
                        }
                    }
                }
            }
        }
"""


UPDATE_VARIANT_STOCK_IMPROVED = """
        mutation updateVariantStock(
            $variantId: ID!,
            $warehouse: ID!,
            $quantity: Int,
        ) {
        productVariantStocksUpdateImproved(
                variantId: $variantId,
                stocks: [{
                    warehouse: $warehouse,
                    quantity: $quantity,
                }]
            ) {
                productVariant {
                    id
                }
                bulkStockErrors {
                    field
                    message
                    code
                }
            }
        }
"""