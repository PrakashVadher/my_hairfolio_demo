module Payments
  class AddCardService
    attr_accessor :user, :card_params, :token, :card
    def initialize(user:, card_params:)
      @user = user
      @card_params = card_params
    end

    def call
      create_token
      if user.stripe_customer_id
        create_card
      else
        create_stripe_customer
      end
      @card
    end

    private

    def create_token
      @token = StripeIntegrator::Token.new(card_params: card_params).create
    end

    def create_stripe_customer
      ActiveRecord::Base.transaction do
        customer = StripeIntegrator::Customer.new(user: user, token: @token).create
        user.update!(stripe_customer_id: customer[:id])
        customer[:cards]&.each { |i| @card = user.cards.create!(stripe_card_id: i) }
      end
    end

    def create_card
      ActiveRecord::Base.transaction do
        card = StripeIntegrator::Card.new(user: user).create(token: @token)
        @card = user.cards.create!(stripe_card_id: card)
      end
    end
  end
end