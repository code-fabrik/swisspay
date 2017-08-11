module Swisspay
  class PaypalsController < ApplicationController
    protect_from_forgery :except => [:create] #Otherwise the request from PayPal wouldn't make it to the controller
    
    include PayPal::SDK::REST

    def create
      PayPal::SDK.configure(
        mode: "sandbox",
        client_id: Swisspay.config.paypal[:api_id],
        client_secret: Swisspay.config.paypal[:api_secret],
        ssl_options: { } )


      case params[:step]
      when 'create_payment'
        create_payment
      when 'execute_payment'
        execute_payment
      end
    end
    
    protected

    def create_payment
      payment = Payment.new({
        intent: 'sale',
        payer: {
          payment_method: 'paypal'
        },
        transactions: [{
          amount: {
            currency: 'CHF',
            total: 10.0
          }
        }],
        redirect_urls: {
          return_url: checkout_url(:confirm_order),
          cancel_url: checkout_url(:confirm_order)
        }
      })
      if payment.create
        render json: { paymentID: payment.id }
      else
        render json: { error: payment.error }, status: 400
      end
    end

    def execute_payment
      payment_id = params[:paymentID]
      payer_id = params[:payerID]
      payment = Payment.find(payment_id)
      if payment.execute(payer_id: payer_id)
        render json: { url: checkout_path(:confirm_order) }
      else
        render json: { error: payment.error }, status: 400
      end
    end
  end
end
