class Api::V1::Warehouse::SessionsController < ApplicationController
  include WarehouseSerializerNamespace

  def create
    user_email = params.dig(:session, :email)&.downcase
    user = User.warehouse.find_by(email: user_email)
    if user && user&.valid_password?(params[:session][:password])
      user.generate_authentication_token!
      user.save!
      success(data: user, status: 200)
    else
      errors(message: I18n.t('warehouse.sessions.invalid_email_password'), status: 422)
    end
  end

  def destroy
    @current_user = User.warehouse.find_by!(auth_token: params[:id])
    @current_user.update!(auth_token: nil)
    success(data: { message: I18n.t("warehouse.sessions.delete") }, status: 200)
  end
end