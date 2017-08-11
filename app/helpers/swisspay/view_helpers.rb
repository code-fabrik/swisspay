module Swisspay
  module ViewHelpers
    def swisspay_payment_form(identifier, amount)
      session['swisspay'] = { 'amount' => amount }
      render  partial: 'swisspay/shop/payment',
              locals: { identifier: identifier, amount: amount }
    end
  end
end
