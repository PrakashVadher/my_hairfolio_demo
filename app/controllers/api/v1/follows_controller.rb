class Api::V1::FollowsController < ApplicationController
  before_action :set_user
  before_action :authenticate_with_token!, except: [:index]

  def create
    follow = Follow.new(follower: current_user, following: @user)
    follow.save
    followinglist = Kaminari.paginate_array(current_user.following.uniq).page(params[:page]).per(params[:limit])
    render json: current_user.following.uniq, status: 201, root: 'users', each_serializer: UserMinimalSerializer, meta: pagination_dict(followinglist)
  end

  def destroy
    follow = Follow.find_by!(following: @user, follower: current_user)
    follow.destroy
    head 204
  end

  def index
    if params[:followings]
      users = Kaminari.paginate_array(@user.following.uniq).page(params[:page]).per(params[:limit])
    elsif params[:friends]
      users = Kaminari.paginate_array(@user.friends.uniq).page(params[:page]).per(params[:limit])
    else
      users = Kaminari.paginate_array(@user.followers.uniq).page(params[:page]).per(params[:limit])
    end
    render json: users, meta: pagination_dict(users), root: 'users', each_serializer: UserMinimalSerializer
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

end
