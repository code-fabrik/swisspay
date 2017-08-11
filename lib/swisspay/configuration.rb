module Swisspay
  class Configuration
    attr_accessor :payment_success, :payment_error,
      :description, :vendor_name,
      :stripe, :postfinance, :paypal

    def initialize
      @payment_success = -> { }
      @payment_error = -> { }
      @description = ''
      @vendor_name = ''
      @stripe = {}
      @postfinance = {}
      @paypal = {}
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
  end
end
