
1. first you need dependencies in zip named: package.zip  (with librarys like to requests or others)
2. modify terraform.tfvars
3. TF_LOG=DEBUG terraform apply -var-file terraform.tfvars
4. expect to output with info: 
 . invoke_url
 . path_resource
5. test apigateway using curl or postman
curl -v -X POST -d '{"key1":43226647,"key2":"Americas","key3":50}' "$invoke_url$path_resource"


------------------------
remain of modules:

    api gateway module .
        1. api rest api
        2. resource
        3. method
        4. integration
        5. method response
        6. integration response
        7. api gateway deployment
        8. cloudwatch
    lambda module
        1. lambda function
        2. layer to apoint package.zip (dependencies)

