require "swisspay/engine"
require 'swisspay/configuration'
require 'swisspay/postfinance'

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
end
