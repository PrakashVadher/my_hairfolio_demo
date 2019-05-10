class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy, :show, :posts, :folios]
  before_action :authenticate_with_token!, only: %i[index fetch_wallet destroy change_password]

  def index
    users = User.where(nil)
    users = users.search(params[:q]) if params[:q]
    users = users.where(account_type: params[:account_type]) if params[:account_type]
    users = users.where.not(id: current_user.blocking.pluck(:id))
    if params[:limit]
      users = users.order(updated_at: :desc).page(params[:page]).per(params[:limit])
    else
      users = users.paginate(pagination_params)
    end
    render json: users, meta: pagination_dict(users)
  end

  def search_profile
    params[:account_type] ||= %i[stylist ambassador owner]
    users = User.includes(:salon, :brand).where(account_type: params[:account_type]).profile_search(params[:q]).distinct.page(params[:page]).per(params[:limit])
    render json: users, meta: pagination_dict(users), each_serializer: UserListSerializer
  end

  def show
    render json: @user, user_id: @user_id
  end


  def create
    user = User.new(user_params)
    if user.save
      Coupons::RewardService.new(referant_user: user, referral_code: params[:referral_code]).apply if params[:referral_code]
      render json: user, user_id: user.id, status: 201
    else
        render json: { errors: user.errors }, status: 422
    end
  end

  def stylist_near_me
    stylists = User.where(account_type:"stylist").within(40, :units => :kms,:origin => [ params[:latitude],params[:longitude] ]).order("id desc")
    stylists = stylists.page(params[:page]).per(params[:limit])

    render json: stylists, user_id: @user_id, meta:pagination_dict(stylists)
  end

  def user_likes
    likes = Like.where(user_id: params[:id])

    render json: likes, status: 201
  end

  def user_favourites  
    user_id = User.where(auth_token:request.headers['Authorization']).map(&:id)   
    favourites = Favourite.where(user_id: params[:id]).order(created_at: :desc)

    render json:favourites, user_id: user_id[0], status: 201
  end

  def update
    if @user.update(user_params)
      render json: @user, user_id: @user.id, status: 201
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  def destroy
    @user.destroy
    render json: { message: "User Deleted" }, status: 201
    head 204
  end

  def posts
    posts = @user.posts.order('created_at desc').page(params[:page]).per(params[:limit])
    render json: posts, meta: pagination_dict(posts)
  end

  def folios
    folios = @user.folios.order('created_at desc').page(params[:page]).per(params[:limit])
    render json: folios, meta: pagination_dict(folios)
  end

  def invite_users
    emails = params[:emails]
    emails.each do |email|
      UserMailer.send_invitation_email(email).deliver_now
    end
    render json: { message: "Invitation send successfully."}, status: 200
  end

  def check_social_user_existence
    exist =
      if params[:facebook_token]
        facebook_user_exist_by_token?(params[:facebook_token])
      elsif params[:instagram_token]
        instagram_user_exist_by_token?(params[:instagram_token])
      else
        false
      end
    success(data: { user_exist: exist }, status: 200)
  end

  def check_referral_code_existence
    code_exist = User.where(referral_code: params[:referral_code]).any? if params[:referral_code]
    success(data: { referral_code_exist: code_exist || false }, status: 200)
  end

  def fetch_wallet
    success(data: current_user.wallet, status: 200)
  end

  def change_password
    if @current_user&.valid_password?(params[:user][:current_password])
      @current_user.update!(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      render json: { message: 'Password Updated Successfully' }, status: 200
    else
      render json: { errors: ['Current password is not valid'] }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:device_id, :facebook_token, :twitter_token, :instagram_token, :default_pinterest_board, :pinterest_token, :email, :password, :password_confirmation, :account_type, :first_name, :last_name, :description, :avatar_url, :avatar_cloudinary_id, :share_facebook, :share_twitter, :share_instagram, :share_pinterest, :share_tumblr, :prof_desc, :years_exp, :salon_id, :career_opportunity, brand_attributes: [:id, :_destroy, :name, :info, :address, :city, :state, :zip, :website, :phone], salon_attributes: [:name, :info, :address, :city, :state, :zip, :website, :phone], educations_attributes: [:name, :year_from, :year_to, :degree_id, :user_id, :website, :id, :_destroy], offerings_attributes: [:user_id, :category_id, :service_id, :price, :id, :_destroy], certificate_ids: [], experience_ids: [])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def facebook_user_exist_by_token?(token)
    response = User.validate_facebook_token(token)
    return false unless response

    Provider.facebook.authentications.where(uid: response.dig('id'))&.any? || User.where(email: response['email']).any?
  end

  def instagram_user_exist_by_token?(token)
    response = User.validate_instagram_token(token)
    return false unless response

    Provider.instagram&.authentications&.where(uid: response&.id)&.any?
  end
end
