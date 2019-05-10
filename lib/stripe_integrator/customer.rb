# frozen_string_literal: true

require_relative './base'

module StripeIntegrator
  class Customer < Base
    attr_accessor :user, :token
    def initialize(user:, token: nil)
      @user = user
      @token = token
    end

    def create
      card_ids = []
      creation_params = { email: user.email }
      creation_params.merge!({ source: token }) if token
      response = Stripe::Customer.create(creation_params)
      response['sources']['data'].map { |i| card_ids << i['id'] if (i['object'] == 'card') }
      { id: response['id'], cards: card_ids }
    end

    def find_customer
      Stripe::Customer.retrieve(user.stripe_customer_id)
    end

    def update(card:)
      Stripe::Customer.update(@user.stripe_customer_id, default_source: card)
    end
  end
end