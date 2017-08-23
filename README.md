# Swisspay

Rails integration for Swiss payment service providers.

Swisspay is a gem that helps you accept payments using various Payment Processing Providers (PSPs). At the moment, it includes support vor Paypal, Stripe and Postfinance (card and e-finance) payments.

It features a simple integration but stays flexible to fit your needs.

**Note: this is a non-free gem. Please use the contact form at [Codefabrik](https://code-fabrik.ch) to get a quote and receive the credentials for installing the gem.**

## Installation
Add this line to your application's Gemfile:

```ruby
source 'https://USERNAME:PASSWORD@gems.code-fabrik.ch' do
  gem 'swisspay'
end
```

And then execute:
```bash
$ bundle
```

## Usage

Add a `stripe_customer_id` column to your user model:

```bash
rails generate migration AddStripeCustomerIdToUsers stripe_customer_id:string
```

Embed the payment partial on your site:

```erb
<%= swisspay_payment_form(@order.id, 200, {
  order_id: @order.id,
  buyer: {
    name: current_user.full_name,
    email: current_user.email,
    street: current_user.street,
    country: 'Schweiz',
    zip: current_user.zip,
    city: current_user.city
  },
  image: asset_path('my_logo.jpg')
}) %>
```

The first two parameters, `order_id` and `amount` are required. The amount must be in **Rappen**. The options are all optional.

Define after payment actions in the initializer, e.g. `config/initializers/swisspay.rb`:

```ruby
Swisspay.configure do |config|
  config.payment_success = -> (controller, app, identifier) do
    order = Order.find(identifier)
    order.update(status: :paid)

    controller.redirect_to app.order_confirmation_path
  end

  config.payment_error = -> (controller, app, identifier, error) do
    Rails.logger.error "Payment error: #{error}"

    controller.redirect_to app.checkout_error_path, alert: error
  end

  config.vendor_name = 'TRM Schweiz'

  config.stripe = {
    secret_key: "sk_test_78nv4zna03vnttab8nw93nsv",
    public_key: "pk_test_nsven89s4nv3497vts9svfgg"
  }

  config.postfinance = {
    pspid: 'mytestPSPID',
    sha_in_pswd: 'dkjfhiurnviyfhjk'
  }
end
```

## License

All rights reserved.

## Terms of Service

Usage of this gem is bound to the following TOS.

1. Licences are granted for a single application. One application may be installed on multiple machines, for instance in a development setup and multistage / CI deploy.
2. Licences are granted for an unlimited time.
3. This gem's source code must not be published or modified.
