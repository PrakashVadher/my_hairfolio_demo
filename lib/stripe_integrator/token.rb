# frozen_string_literal: true

require_relative './base'

module StripeIntegrator
  class Token < Base
    attr_accessor :card_params, :customer
    def initialize(card_params:, customer: nil)
      @card_params = card_params
      @customer = customer
    end

    def create
      Stripe::Token.create(token_params)
    end

    private

    def token_params
      params =
        { card: {
          number: card_params[:number],
          exp_month: card_params[:expiry_month],
          exp_year: card_params[:expiry_year],
          cvc: card_params[:cvc]
        } }
      params[:customer] = customer if customer
      params
    end
  end
end
