module Swisspay
  class StripesController < ApplicationController
    protect_from_forgery except: [:create]
    before_action :load_session
    
    def create
      Stripe.api_key = Swisspay.configuration.stripe[:secret_key]

      customer = Stripe::Customer.create(
        email: params[:stripeEmail],
        source: params[:stripeToken]
      )

      charge = Stripe::Charge.create(
        customer:    customer.id,
        amount:      @amount,
        description: 'Bestellung ' + @identifier.to_s,
        currency:    'chf'
      )

      Swisspay.configuration.payment_success.call(self, main_app, @identifier, :stripe)

    rescue Stripe::CardError => e
      Swisspay.configuration.payment_error(self, main_app, @identifier, :stripe, e.message)
    end

    private

    def load_session
      @amount = session['swisspay']['amount']
      @identifier = session['swisspay']['identifier']
    end
  end
end
