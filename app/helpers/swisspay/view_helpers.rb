module Swisspay
  module ViewHelpers
    def swisspay_payment_form(identifier, amount, options = {})
      session['swisspay'] = { 'amount' => amount }
      render  partial: 'swisspay/shop/payment',
              locals: { identifier: identifier, amount: amount, base_url: request.base_url, options: options }
    end
  end
end
