# frozen_string_literal: true

class Api::V1::BankAccountsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    pagination_params = { limit: params[:limit] || 10,
                          starting_after: params[:starting_after] }
    return success(data: { bank_accounts: [], has_more: false }, status: 200) unless @current_user.stripe_account_id.present?
    @bank_accounts_list =
      StripeIntegrator::BankAccount
      .new(stripe_account_id: @current_user.stripe_account_id)
      .list_bank_account(pagination_params)
    success(data: serialize_bank_account_list, status: 200)
  end

  def get_bank_details
    return success(data: {}, status: 200) unless @current_user.stripe_account_id.present?
    stripe_account = StripeIntegrator::Account.new(user: @current_user).retrieve
    bank_account = stripe_account.external_accounts&.data&.dig(0)
    success(data: serialize_bank_object(bank_account), status: 200)
  end

  def create
    stripe_account =
      if @current_user.stripe_account_id
        StripeIntegrator::BankAccount
          .new(stripe_account_id: @current_user.stripe_account_id)
          .create(external_account_param: bank_account_params)
      else
        StripeIntegrator::Account.new(user: @current_user)
                                 .create(external_account_param: bank_account_params)
      end
    bank_account =stripe_account.external_accounts&.data&.dig(0)
    success(data: serialize_bank_object(bank_account), status: 200)
  end

  def update
    StripeIntegrator::BankAccount
      .new(stripe_account_id: @current_user.stripe_account_id)
      .update(bank_account: params[:id], params: bank_account_update_params)
    success(data: { message: I18n.t('bank_account.updated') }, status: 200)
  end

  def destroy
    StripeIntegrator::BankAccount
      .new(stripe_account_id: @current_user.stripe_account_id)
      .delete(bank_account: params[:id])
    success(data: { message: I18n.t('bank_account.deleted') }, status: 200)
  end

  private

  def bank_account_params
    params.require(:bank_account)
          .permit(:country, :currency, :account_number, :account_holder_name, :routing_number, :account_holder_type)
  end

  def bank_account_update_params
    params.require(:bank_account).permit(:account_holder_name, :account_holder_type, :default_for_currency)
  end

  def serialize_bank_account_list
    response = { bank_accounts: [], has_more: @bank_accounts_list['has_more'] }
    @bank_accounts_list['data'].each do |object|
      response[:bank_accounts] << serialize_bank_object(object)
    end
    response
  end

  def serialize_bank_object(object)
    return {} unless object.present?
    serialize_object = object.to_h.slice(:id, :account_holder_name, :account_holder_type, :bank_name, :country,
                                         :currency, :default_for_currency, :routing_number)
    serialize_object[:account_number] = '*' * 8 + object['last4']
    serialize_object
  end
end