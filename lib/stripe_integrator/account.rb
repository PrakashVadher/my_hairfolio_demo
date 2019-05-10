# frozen_string_literal: true

require_relative './base'

module StripeIntegrator
  class Account
    attr_accessor :user
    def initialize(user:)
      @user = user
    end

    def create(external_account_param: {})
      response = Stripe::Account.create(account_params(external_account_param))
      @user.update!(stripe_account_id: response['id'])
      Rails.logger.debug(response)
      response['object'] == 'account' ? response : nil
    end

    def retrieve
      Stripe::Account.retrieve(user.stripe_account_id)
    end

    private


    def account_params(external_account_param)
      dob = Time.now.utc - 18.year
      params = {
                type: 'custom',
                legal_entity: {
                    first_name: user.first_name || 'test',
                    last_name: user.last_name || 'user',
                    type:'individual',
                    dob: {
                        day: dob.day,
                        month: dob.month,
                        year: dob.year
                    },
                    address: {
                        line1: '1764  Heavner Court',
                        city: 'Waukee',
                        state: 'Iowa',
                        postal_code: 50263
                    },
                    ssn_last_4: 6789
                },
                tos_acceptance: {
                    date: Time.now.to_i,
                    ip: '202.131.117.90'
                }
      }
      return params unless external_account_param

      params[:external_account] = {
        object: 'bank_account',
        country: external_account_param[:country],
        currency: external_account_param[:currency],
        account_number: external_account_param[:account_number],
        account_holder_name: external_account_param[:account_holder_name],
        routing_number: external_account_param[:routing_number]
      }
      params
    end
  end
end