var qs = require('qs');

exports.handler = async (event) => {

  console.log(JSON.stringify(event));
  var purchase = '', amount = '', transaction = '';

  if(event['body'] !== undefined) {
    var obj = qs.parse(event['body']);
    transaction = obj['transactionToken'];
    purchase = event['queryStringParameters']['purchase'];
    amount = event['queryStringParameters']['amount'];
  }

  const response = {
    statusCode: 301,
    headers: {
      // Location: [process.env.STOREFRONT_URL_LANDING, transaction, purchase, amount].join('/')
      Location: [event['headers']['origin'], process.env.STOREFRONT_URL_LANDING, transaction, purchase].join('/')
    }
  };

  return response;
};
