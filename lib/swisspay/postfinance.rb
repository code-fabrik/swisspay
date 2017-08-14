module Swisspay
  class Postfinance
    def self.form_data(base_url, identifier, amount, options)
      { 
        ACCEPTURL: Swisspay::Engine.routes.url_helpers.accept_postfinance_url(host: base_url, identifier: identifier),
        AMOUNT: amount,
        CANCELURL: Swisspay::Engine.routes.url_helpers.cancel_postfinance_url(host: base_url, identifier: identifier),
        CN: options[:buyer][:name],
        CURRENCY: 'CHF',
        DECLINEURL: Swisspay::Engine.routes.url_helpers.decline_postfinance_url(host: base_url, identifier: identifier),
        EMAIL: options[:buyer][:email],
        EXCEPTIONURL: Swisspay::Engine.routes.url_helpers.exception_postfinance_url(host: base_url, identifier: identifier),
        LANGUAGE: 'de_DE',
        ORDERID: options[:order_id].to_s + Swisspay.order_id_suffix,
        OWNERADDRESS: options[:buyer][:street],
        OWNERCTY: options[:buyer][:country],
        #OWNERTELNO: '031 331 83 83',
        OWNERTOWN: options[:buyer][:city],
        OWNERZIP: options[:buyer][:zip],
        PSPID: Swisspay.configuration.postfinance[:pspid]
      }
    end

    def self.generate_signature(form_data)
      self.sha_for(form_data)
    end

    def self.check_signature(params)
      up_sorted = params.map{|k,v| [k.upcase, v]}.sort_by{|k,v| k}
      shasig = up_sorted.select { |k,v| k == "SHASIGN" }.first.last.downcase
      other_params = up_sorted.reject { |k,v| k == "SHASIGN" || v == "" }
      calc_sig = self.sha_for(other_params)
      shasig == calc_sig
    end

    private

    def self.sha_for(data)
      secret_sig = Swisspay.configuration.postfinance[:sha_in_pswd]
      string = data.reject { |k,v| v.nil? }.map { |k, v| "#{k}=#{v}" }.join(secret_sig)
      string << secret_sig
      digest = Digest::SHA1.hexdigest(string)
      digest
    end
  end
end
