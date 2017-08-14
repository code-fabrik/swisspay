# Swisspay

Swisspay is a gem that helps you accept payments using various Payment Processing Providers (PSPs). At the moment, it includes support vor Paypal, Stripe and Postfinance (card and e-finance) payments.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'swisspay'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install swisspay
```

## Usage

Add a `stripe_customer_id` column to your user model:

```bash
rails generate migration AddStripeCustomerIdToUsers stripe_customer_id:string
```

Embed the payment partial on your site:

```erb
<%= swisspay_payment_form(@order.id, (@order.total_price * 100).to_i, {
  order_id: @order.id,
  buyer: {
    name: current_user.full_name,
    email: current_user.email,
    street: current_user.street,
    country: 'Schweiz',
    zip: current_user.zip,
    city: current_user.city
  },
  image: asset_path('trm.jpg')
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
    secret_key: "sk_test_xvfPKPHPv2hSbeoj5OqakPAg",
    public_key: "pk_test_wIRpM69mpnv0qPesaIf3s2v2"
  }

  config.postfinance = {
    pspid: 'trmschweizTEST',
    sha_in_pswd: 'Mysecretsig1875!?'
  }
end
```

## Contributing
Contribution directions go here.

## License

All rights reserved.
