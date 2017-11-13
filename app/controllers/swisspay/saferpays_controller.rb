module Swisspay
  class SaferpaysController < ApplicationController
    before_action :load_session
    
    def success
      token = session['swisspay']['token']
      identifier = session['swisspay']['identifier']
      valid = Swisspay::Saferpay.check_payment(identifier, token)
      Rails.logger.error "NOT PAID" if !valid

      Swisspay.configuration.payment_success.call(self, main_app, @identifier, :saferpay)
    end

    def fail
      Swisspay.configuration.payment_error.call(self, main_app, @identifier, :saferpay, :fail)
    end

    private

    def load_session
      @amount = session['swisspay']['amount']
      @identifier = session['swisspay']['identifier']
    end
  end
end
