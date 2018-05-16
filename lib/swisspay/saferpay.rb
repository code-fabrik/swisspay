require 'net/http'
require 'json'
require 'securerandom'

module Swisspay
  class Saferpay
    API_BASE = 'https://test.saferpay.com/api'
    PAYMENT_PAGE_INIT = '/Payment/v1/PaymentPage/Initialize'
    PAYMENT_PAGE_ASSERT = '/Payment/v1/PaymentPage/Assert'
    PAYMENT_PAGE_CAPTURE = '/Payment/v1/Transaction/Capture'

    def self.payment_url(base_url, options)
      response = post(API_BASE + PAYMENT_PAGE_INIT, payment_page_init_data(base_url, options))
      data = JSON.parse(response.delete("\\")[1..-2])
      token = data['Token']
      redirect_url = data['RedirectUrl']
      return redirect_url, token
    end

    def self.check_payment(identifier, token)
      response = post(API_BASE + PAYMENT_PAGE_ASSERT, payment_page_assert_data(identifier, token))
      data = JSON.parse(response.delete("\\")[1..-2])
      result = data["Transaction"]["Status"] == 'AUTHORIZED'
      trx_id = data["Transaction"]["Id"]
      amount = data["Transaction"]["Amount"]["Value"]

      [result, trx_id, amount]
    end

    def self.capture(identifier, transaction_id, amount)
      response = post(API_BASE + PAYMENT_PAGE_CAPTURE, payment_page_capture_data(identifier, transaction_id, amount))
      data = JSON.parse(response.delete("\\")[1..-2])
      return data["OrderId"]
    end

    private

    def self.payment_page_init_data(base_url, options)
      {
        "RequestHeader": {
          "SpecVersion": "1.6",
          "CustomerId": Swisspay.configuration.saferpay[:customer_id],
          "RequestId": options['identifier'],
          "RetryIndicator": 0
        },
        "TerminalId": Swisspay.configuration.saferpay[:terminal_id],
        "Payment": {
          "Amount": {
            "Value": options['amount'],
            "CurrencyCode": "CHF"
          },
          "OrderId": options['identifier'],
          "Description": options['description']
        },
        "ReturnUrls": {
          "Success": Swisspay::Engine.routes.url_helpers.success_saferpay_url(host: base_url),
          "Fail": Swisspay::Engine.routes.url_helpers.fail_saferpay_url(host: base_url)
        }
      }
    end

    def self.payment_page_assert_data(identifier, token)
      {
        "RequestHeader": {
          "SpecVersion": "1.6",
          "CustomerId": Swisspay.configuration.saferpay[:customer_id],
          "RequestId": identifier,
          "RetryIndicator": 0
        },
        "Token": token
      }
    end

    def self.payment_page_capture_data(identifier, transaction_id, amount)
      {
        "RequestHeader": {
          "SpecVersion": "1.6",
          "CustomerId": Swisspay.configuration.saferpay[:customer_id],
          "RequestId": identifier,
          "RetryIndicator": 0
        },
        "TransactionReference": {
          "TransactionId": transaction_id
        },
        "Amount": {
          "Value": amount,
          "CurrencyCode": 'CHF'
        }
      }
    end

    def self.post(url, data)
      uri = URI(url)
      api_user = Swisspay.configuration.saferpay[:api_user]
      api_pass = Swisspay.configuration.saferpay[:api_pass]
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.set_debug_output($stdout)
      req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json; charset=utf-8', 'Accept' => 'application/json')
      req.body = data.to_json
      req.basic_auth api_user, api_pass 
      res = http.request(req)
      res.body.inspect
    rescue => e
      puts "failed #{e.inspect}"
      nil
    end
  end
end
