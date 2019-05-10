class Api::V1::WalletsController < ApplicationController
  before_action :authenticate_with_token!

  def payout
    raise ActionController::ParameterMissing.new(:bank_account_id) unless params[:bank_account_id]

    if @current_user.stripe_account_id
      amount = @current_user.wallet&.amount
      return errors(message: I18n.t('wallet.insufficient_amount'), status: 422) if amount_invalid?(amount)

      StripeIntegrator::Payout.create(stripe_account_id: @current_user.stripe_account_id,
                                      destination: params[:bank_account_id],
                                      amount: amount)
      @current_user.wallet.update!(amount: 0)
      success(data: { message: I18n.t('wallet.payout_success') }, status: 200)
    else
      errors(message: I18n.t('bank_account.not_associated'), status: 422)
    end
  end

  def commission_list
    commission_list = @current_user.wallet_commission_lists.order(created_at: :desc).paginate(pagination_params)
    success(data: commission_list, status: 200, meta: pagination_dict(commission_list))
  end

  private

  def amount_invalid?(amount = nil)
    return true unless amount

    !amount&.positive?
  end
end