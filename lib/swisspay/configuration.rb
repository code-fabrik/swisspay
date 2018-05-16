module Swisspay
  class Configuration
    attr_accessor :payment_success, :payment_error, :payment_authorized,
      :description, :vendor_name,
      :stripe, :postfinance, :paypal, :saferpay

    def initialize
      @payment_success = -> { }
      @payment_error = -> { }
      @payment_authorized = -> { }
      @description = ''
      @vendor_name = ''
      @stripe = {}
      @postfinance = {}
      @paypal = {}
      @saferpay = {}
    end

    def stripe?
      @stripe != {}
    end

    def paypal?
      @paypal != {}
    end

    def postfinance?
      @postfinance != {}
    end

    def saferpay?
      @saferpay != {}
    end
  end
end
