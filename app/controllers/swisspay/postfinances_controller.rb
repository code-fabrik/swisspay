module Swisspay
  class PostfinancesController < ApplicationController
    def accept
      valid = Swisspay::Postfinance.check_signature(params.except(:action, :controller))

      Rails.logger.error "SIGNATURE DOES NOT MATCH FINGERPRINT" if !valid

      identifier = params[:identifier]
      Swisspay.configuration.payment_success.call(self, main_app, identifier)
    end

    def cancel
      identifier = params[:identifier]
      Swisspay.configuration.payment_error(self, main_app, identifier, :user_cancelled)
    end

    def decline
      identifier = params[:identifier]
      Swisspay.configuration.payment_error(self, main_app, identifier, :card_declined)
    end

    def exception
      identifier = params[:identifier]
      Swisspay.configuration.payment_error(self, main_app, identifier, :server_error)
    end
  end
end
