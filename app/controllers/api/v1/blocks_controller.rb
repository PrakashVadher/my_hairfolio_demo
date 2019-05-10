class Api::V1::BlocksController < ApplicationController
  before_action :set_user
  before_action :authenticate_with_token!, except: [:index]

  def create
    Block.find_or_create_by(blocker: current_user, blocking: @user)
    Follow.where(following: @user, follower: current_user).destroy_all
    users = Kaminari.paginate_array(current_user.blocking).page(params[:page]).per(params[:limit])
    render json: users, meta: pagination_dict(users), status: 201, root: 'users', each_serializer: UserMinimalSerializer
  end

  def destroy
    block = Block.find_by!(blocking: @user, blocker: current_user)
    block.destroy
    head 204
  end

  def index
    users = Kaminari.paginate_array(@user.blocking).page(params[:page]).per(params[:limit])
    render json: users, meta: pagination_dict(users), root: 'users', each_serializer: UserMinimalSerializer
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end
end
