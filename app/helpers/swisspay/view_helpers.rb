module Swisspay
  module ViewHelpers
    def swisspay_payment_form(identifier, amount, options = {})
      identifier = identifier.to_s + Swisspay::order_id_suffix
      session['swisspay'] = { 'amount' => amount, 'identifier' => identifier }
      render  partial: 'swisspay/shop/payment',
              locals: { identifier: identifier, amount: amount, base_url: request.base_url, options: options }
    end
  end
end
