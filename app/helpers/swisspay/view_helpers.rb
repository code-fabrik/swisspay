module Swisspay
  module ViewHelpers
    def swisspay_payment_form(options = {})
      identifier = identifier.to_s + Swisspay::order_id_suffix

      default_options = { labels: {}, html: { class: 'button pay-button', name: nil } }
      session[:swisspay] = default_options.merge(options)

      render partial: 'swisspay/shop/payment'
    end
  end
end
