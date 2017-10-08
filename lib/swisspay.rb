require "swisspay/engine"
require 'swisspay/configuration'
require 'swisspay/postfinance'
require 'swisspay/saferpay'

module Swisspay
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.order_id_suffix
    if Rails.env.production?
      ''
    else
      "_TEST_" + (100 + rand(899)).to_s
    end
  end
end
