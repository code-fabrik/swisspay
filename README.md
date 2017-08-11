# Swisspay
Short description and motivation.

## Usage
How to use my plugin.

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

Define `default_url_options` in ApplicationController:
```ruby
def default_url_options
  { host: 'example.com' }
end
```

Embed the payment partial on your site:

```erb
<%= swisspay_payment_form(@order.id, @order.total_price) %>
```

Add a `stripe_customer_id` column to your user model:

```bash
rails generate migration AddStripeCustomerIdToUsers stripe_customer_id:string
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
