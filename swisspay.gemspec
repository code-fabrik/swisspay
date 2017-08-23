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
  s.description = "Easily accept payments from different payment providers such as Stripe, Paypal and Postfinance."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency 'rails', '~> 5.0', '>= 5.0.2'

  s.add_development_dependency 'pg', '~> 0'
end
