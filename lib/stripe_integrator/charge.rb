# frozen_string_literal: true

require_relative './base'

module StripeIntegrator
  class Charge < Base
    attr_accessor :customer, :card, :amount, :options

    def initialize(user:, card: nil, amount:, options: {})
      @customer = user
      @card = card || user.primary_card
      @amount = amount
      @options = options
    end

    def create
      Stripe::Charge.create(
        amount: (amount * 100).to_i,
        currency: 'usd',
        source: @card.stripe_card_id,
        description: options.dig(:description),
        customer: @customer.stripe_customer_id
      )
    end
  end
end