# frozen_string_literal: true

require_relative './base'

module StripeIntegrator
  class Payout
    class << self
      def create(stripe_account_id:, destination:, amount:)
        Stripe::Transfer.create(amount: (amount * 100).to_i,
                                currency: "usd",
                                destination: stripe_account_id)

        Stripe::Payout.create(
          {
            amount: (amount * 100).to_i,
            currency: 'usd',
            destination: destination
          },
          stripe_account: stripe_account_id
        )
      end
    end
  end
end