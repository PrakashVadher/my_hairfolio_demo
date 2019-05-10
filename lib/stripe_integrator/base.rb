# frozen_string_literal: true

require 'stripe'
Stripe.api_key = ENV['STRIPE_SECRET_KEY']

module StripeIntegrator
  class Base
  end
end
