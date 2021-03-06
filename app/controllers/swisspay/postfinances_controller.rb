module Swisspay
  class PostfinancesController < ApplicationController
    before_action :load_session
    
    def accept
      valid = Swisspay::Postfinance.check_signature(params.except(:action, :controller))

      Rails.logger.error "SIGNATURE DOES NOT MATCH FINGERPRINT" if !valid

      raise StandardError, 'AMOUNT MISMATCH' if (@amount / 100.to_f).to_f != params['amount'].to_f
      raise StandardError, 'IDENTIFIER MISMATCH' if @identifier != params[:orderID]

      Swisspay.configuration.payment_success.call(self, main_app, @identifier, :postfinance)
    end

    def cancel
      Swisspay.configuration.payment_error.call(self, main_app, @identifier, :postfinance, :user_cancelled)
    end

    def decline
      Swisspay.configuration.payment_error.call(self, main_app, @identifier, :postfinance, :card_declined)
    end

    def exception
      Swisspay.configuration.payment_error.call(self, main_app, @identifier, :postfinance, :server_error)
    end

    private

    def load_session
      @amount = session['swisspay']['amount']
      @identifier = session['swisspay']['identifier']
    end
  end
end
