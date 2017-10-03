require 'net/http'
require 'json'
require 'securerandom'

API_USER = 'API_242509_09707641'
API_PASS = '034q5n9384759347vs89na4vr78oH'
API_AUTH = 'Basic QVBJXzI0MjUwOV8wOTcwNzY0MTowMzRxNW45Mzg0NzU5MzQ3dnM4OW5hNHZyNzhvSA=='

CUSTOMER_ID = '242509'
REQUEST_ID = SecureRandom.hex

TERMINAL_ID = '17874560'

API_BASE = 'https://test.saferpay.com/api'
PAYMENT_PAGE_INIT = '/Payment/v1/PaymentPage/Initialize'
PAYMENT_PAGE_ASSERT = '/Payment/v1/PaymentPage/Assert'

def payment_page_init_data
  {
    "RequestHeader": {
      "SpecVersion": "1.6",
      "CustomerId": CUSTOMER_ID,
      "RequestId": REQUEST_ID,
      "RetryIndicator": 0
    },
    "TerminalId": TERMINAL_ID,
    "Payment": {
      "Amount": {
        "Value": "100",
        "CurrencyCode": "CHF"
      },
      "OrderId": SecureRandom.hex,
      "Description": "Description of payment"
    },
    "ReturnUrls": {
      "Success": 'https://merchanthost/success',
      "Fail": 'https://merchanthost/fail'
    }
  }
end

def payment_page_assert_data(token)
  {
    "RequestHeader": {
      "SpecVersion": "1.6",
      "CustomerId": CUSTOMER_ID,
      "RequestId": REQUEST_ID,
      "RetryIndicator": 0
    },
    "Token": token
  }
end

def post(url, data)
  uri = URI(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.set_debug_output($stdout)
  req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json; charset=utf-8', 'Accept' => 'application/json', 'Authorization' => API_AUTH)
  req.body = data.to_json
  #req.basic_auth API_USER, API_PASS 
  res = http.request(req)
  res.body.inspect
rescue => e
  puts "failed #{e.inspect}"
  nil
end

response = post(API_BASE + PAYMENT_PAGE_INIT, payment_page_init_data)
data0 = JSON.parse JSON.parse(response)
token = data0['Token']
puts "Captured token: " + token

gets.chomp

post(API_BASE + PAYMENT_PAGE_ASSERT, payment_page_assert_data(token))

