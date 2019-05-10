# frozen_string_literal: true

Dir["./*.rb"].each {|file| require file }

module StripeIntegrator
  class Card < Base
    attr_accessor :customer
    def initialize(user:)
      @customer = StripeIntegrator::Customer.new(user: user).find_customer
    end

    def create(token:)
      #card_fingerprint = token.card.fingerprint
      #fingerprint_already_exists = customer.sources.any? { |source| source[:fingerprint] == card_fingerprint }
      #raise Errors::CardExistError if fingerprint_already_exists

      response = customer.sources.create({:source => token})
      response['object'] == 'card' ? response['id'] : nil
    end

    def retrieve(card_id)
      card = customer.sources.retrieve(card_id)
      card['object'] == 'card' ? card :  nil
    end

    def delete_card(card_id)
      customer.sources.retrieve(card_id).delete
    end

    def list_cards(limit: nil, starting_after: nil)
      options = { object: 'card' }
      options.merge!({ limit: limit}) if limit
      options.merge!({ starting_after: starting_after}) if starting_after
      customer.sources.list(options)
    end
  end
end