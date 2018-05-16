module Swisspay
  class SaferpaysController < ApplicationController
    before_action :load_session

    def create

      base_url = request.base_url
      options = session['swisspay']

      url, token = Swisspay::Saferpay.payment_url(base_url, options)
      session['swisspay']['token'] = token
      session['swisspay']['authorize'] = true
      redirect_to url
    end
    
    def success
      valid,trx_id,amount = Swisspay::Saferpay.check_payment(@identifier, @token)
      Rails.logger.error "NOT PAID" if !valid

      if session['swisspay']['authorize']
        Swisspay.configuration.payment_authorized.call(self, main_app, @identifier, :saferpay, {transaction_id: trx_id})
      else
        identifier = Swisspay::Saferpay.capture(@identifier, trx_id, amount)
        Swisspay.configuration.payment_success.call(self, main_app, identifier, :saferpay)
      end
    end

    def fail
      Swisspay.configuration.payment_error.call(self, main_app, @identifier, :saferpay, :fail)
    end

    private

    def load_session
      @token = session['swisspay']['token']
      @amount = session['swisspay']['amount']
      @identifier = session['swisspay']['identifier']
    end
  end
end
