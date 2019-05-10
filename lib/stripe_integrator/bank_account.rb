# frozen_string_literal: true

require_relative './base'

module StripeIntegrator
  class BankAccount
    attr_accessor :account
    def initialize(stripe_account_id:)
      @account = Stripe::Account.retrieve(stripe_account_id)
    end

    def create(external_account_param: {})
      token = create_bank_account_token(external_account_param)
      raise Errors::BankAccountExistError if account.external_accounts.any? {|source| source[:fingerprint] == token&.bank_account&.fingerprint}
      account.external_accounts.create({ external_account: token })
      account.save
      account
    end

    def list_bank_account(pagination_options = {})
      options = { limit: pagination_options[:limit], starting_after: pagination_options[:starting_after] }
      account.external_accounts.list(options)
    end

    def update(bank_account:, params: {})
      bank_account = account.external_accounts.retrieve(bank_account)
      bank_account.update_attributes(bank_update_params(params))
      bank_account.save
    end

    def delete(bank_account:)
      account.external_accounts.retrieve(bank_account).delete
    end

    private

    def bank_account_params(params)
      {
        object: 'bank_account',
        country: params[:country],
        currency: params[:currency],
        account_number: params[:account_number],
        account_holder_name: params[:account_holder_name],
        routing_number: params[:routing_number],
        account_holder_type: params[:account_holder_type]
      }
    end

    def bank_update_params(params)
      {
        account_holder_name: params[:account_holder_name],
        account_holder_type: params[:account_holder_type],
        default_for_currency: params[:default_for_currency] || false
      }
    end

    def create_bank_account_token(params)
      Stripe::Token.create({
                               bank_account: bank_account_params(params)
                           })

    end
  end
end
