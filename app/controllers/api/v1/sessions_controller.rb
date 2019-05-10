class Api::V1::SessionsController < ApplicationController
  include Registrable

  def facebook
    response = User.validate_facebook_token(params[:facebook_token])
    if response
      response['token'] = params[:facebook_token]
      user = User.find_by(email: response['email'])
      provider = Provider.where(name: 'facebook').first
      authentication = provider.authentications.where(uid: response['id']).first
      if authentication
        sign_in_user user: authentication.user
        render json: authentication.user, user_id: authentication.user.id, status: 200, location: [:api, authentication.user]
      elsif user
        Authentication.create_from_koala(response, user, provider)
        sign_in_user user: user
        render json: user, user_id: user.id, status: 200, location: [:api, user]
      else
        user = User.create_from_social(response)
        if user
          sign_in_user user: user
          Authentication.create_from_koala(response, user, provider)
          Coupons::RewardService.new(referant_user: user, referral_code: params[:referral_code]).apply if params[:referral_code]
          render json: user, user_id: user.id, status: 200, location: [:api, user]
        else
          render json: { errors: "Invalid user"}, status: 422
        end
      end
    else
      render json: { errors: "Invalid facebook token" }, status: 422
    end
  end

  def instagram
    response = User.validate_instagram_token(params[:instagram_token])
    if response
      provider = Provider.where(name: 'instagram').first
      authentication = provider.authentications.where(uid: response.id).first
      if authentication
        sign_in_user user: authentication.user
        render json: authentication.user, user_id: authentication.user&.id,status: 200, location: [:api, authentication.user]
      elsif current_user
        Authentication.create_from_instagram(params[:google_token], response, current_user, provider)
        sign_in_user user: current_user
        render json: current_user,user_id: current_user.id, status: 200, location: [:api, current_user]
      else
        user = User.create_from_social(response)
        if user
          sign_in_user user: user
          Authentication.create_from_instagram(params[:google_token], response, user, provider)
          Coupons::RewardService.new(referant_user: user, referral_code: params[:referral_code]).apply if params[:referral_code]
          render json: user,user_id: user.id, status: 200, location: [:api, user]
        else
          render json: { errors: "Invalid user"}, status: 422
        end
      end
    else
      render json: { errors: "Invalid instagram token" }, status: 422
    end
  end

  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = User.find_by(email: user_email)
    if user && user&.valid_password?(user_password)      
      user.update(latitude:params[:session][:latitude],longitude:params[:session][:longitude])
      sign_in_user user: user
      render json: user,user_id: user.id, status: 200, location: [:api, user]
    else
      render json: { errors: "Invalid username or password" }, status: 422
    end
  end

  def recover
    user = User.find_by('lower(email) = ?', params[:email].downcase) rescue nil
    if user
      password = Devise.friendly_token.first(12)

      user.update_attributes(password: password, password_confirmation: password)
      UserMailer.password_reset(user, password).deliver_now
      render json: { message: "Password email resent"}
    else
      render json: { errors: "User not found"}, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    if user
      user.generate_authentication_token!
      user.save
      head 204
    else
      head 404
    end
  end

  def environment
    render json: {
      facebook_app_id: Rails.application.secrets.facebook_app_id,
      facebook_redirect_url: Rails.application.secrets.facebook_redirect_url,
      insta_client_id: Rails.application.secrets.insta_client_id,
      insta_redirect_url: Rails.application.secrets.insta_redirect_url,
      cloud_name: Rails.application.secrets.cloud_name,
      cloud_preset: Rails.application.secrets.cloud_preset
    }
  end

  private

  def sign_in_user(user:)
    sign_in user
    register_token_and_device_id user
    user.save
  end
end
