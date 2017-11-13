$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "swisspay/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "swisspay"
  s.version     = Swisspay::VERSION
  s.authors     = ["Lukas_Skywalker"]
  s.email       = ["lukas.diener@hotmail.com"]
  s.homepage    = "https://code-fabrik.ch"
  s.summary     = "Swiss PSP gem"
  s.description = "Easily accept payments from different payment providers such as Stripe, Paypal, Postfinance and SIX."
  s.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata["allowed_push_host"] = "https://gems.code-fabrik.ch"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency 'rails', '~> 5.0', '>= 5.0.2'
  s.add_runtime_dependency 'paypal-sdk-rest', '~> 1.6', '>= 1.6.0'
end
