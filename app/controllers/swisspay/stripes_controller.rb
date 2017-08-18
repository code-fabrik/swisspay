module Swisspay
  class StripesController < ApplicationController
    protect_from_forgery except: [:create]
    before_filter :load_session
    
    def create
      Stripe.api_key = Swisspay.configuration.stripe[:secret_key]

      if current_user.stripe_customer_id.nil?
        customer = Stripe::Customer.create(
          email: params[:stripeEmail],
          source: params[:stripeToken]
        )

        current_user.update(stripe_customer_id: customer.id)
      end


      charge = Stripe::Charge.create(
        customer:    current_user.stripe_customer_id,
        amount:      @amount,
        description: 'Bestellung ' + @identifier.to_s,
        currency:    'chf'
      )

      Swisspay.configuration.payment_success.call(self, main_app, @identifier)

    rescue Stripe::CardError => e
      Swisspay.configuration.payment_error(self, main_app, @identifier, e.message)
    end

    private

    def load_session
      @amount = session['swisspay']['amount']
      @identifier = session['swisspay']['identifier']
    end
  end
end
