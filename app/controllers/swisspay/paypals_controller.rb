require 'paypal-sdk-rest'

module Swisspay
  class PaypalsController < ApplicationController
    protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller
    before_action :load_session

    include PayPal::SDK::REST

    def create
      PayPal::SDK.configure(
        mode: "sandbox",
        client_id: Swisspay.configuration.paypal[:api_id],
        client_secret: Swisspay.configuration.paypal[:api_secret],
        ssl_options: { } )


      case params[:step]
      when 'create_payment'
        create_payment
      when 'execute_payment'
        execute_payment
      end
    end

    def show
      if params[:action] == 'accept'
        Swisspay.configuration.payment_success.call(self, main_app, @identifier, :paypal)
      elsif params[:action] == 'cancel'
        Swisspay.configuration.payment_error(self, main_app, @identifier, :paypal, :cancel)
      end
    end
    
    protected

    def create_payment
      # send a create payment request to the API
      payment = Payment.new({
        intent: 'sale',
        payer: {
          payment_method: 'paypal'
        },
        transactions: [{
          amount: {
            currency: 'CHF',
            total: (@amount / 100.0)
          },
          invoice_number: @identifier
        }],
        # PayPal does not automatically call these URLs. PayPal invokes your onAuthorize function
        # when the buyer authorizes the payment. At this point you can choose to redirect the buyer.
        redirect_urls: {
          return_url: Swisspay::Engine.routes.url_helpers.paypal_url(host: request.base_url, action: :return),
          cancel_url: Swisspay::Engine.routes.url_helpers.paypal_url(host: request.base_url, action: :cancel)
        }
      })
      if payment.create
        # send payment id back to js script
        render json: { paymentID: payment.id }
      else
        render json: { error: payment.error }, status: 400
      end
    end

    def execute_payment
      payment_id = params[:paymentID]
      payer_id = params[:payerID]
      payment = Payment.find(payment_id)
      remote_identifier = payment.transactions.first.invoice_number
      remote_amount = payment.transactions.first.amount.total

      raise StandardError, 'AMOUNT MISMATCH' if (@amount / 100.to_f).to_f != remote_amount.to_f
      raise StandardError, 'IDENTIFIER MISMATCH' if @identifier != remote_identifier

      if payment.execute(payer_id: payer_id)
        Swisspay.configuration.payment_success.call(self, main_app, @identifier, :paypal)
      else
        Swisspay.configuration.payment_error.call(self, main_app, @identifier, :paypal, payment.error)
      end
    end

    private

    def load_session
      @amount = session['swisspay']['amount']
      @identifier = session['swisspay']['identifier']
    end
  end
end
