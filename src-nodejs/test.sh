#!/usr/bin/env bash

echo "Running Authorizer Lambda Function tests ..."

allTestsPassed=true
export STOREFRONT_URL_LANDING=checkout/payment

# Valid Request Test
result=$(node_modules/.bin/lambda-local -v 1 -l index.js -h handler -e tests/validRequestTest.js -t 20 | grep \"http://localhost:3000/checkout/payment/B8614366B9F948E3A14366B9F968E3F9/718133720624\")
if [[ -z "${result}" ]]; then
    allTestsPassed=false
    echo $result
    echo "✗ validTokenTest case"
else
    echo "✓ validTokenTest case"
fi

echo "=============================================="

if [ "$allTestsPassed" = false ] ; then
    exit 1
fi
