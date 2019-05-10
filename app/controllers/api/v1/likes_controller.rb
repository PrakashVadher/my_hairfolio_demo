class Api::V1::LikesController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_post
  before_action :check_user

  def index
    likes = @post.likes.page(params[:page]).per(params[:limit])
    render json: likes, user_id: @user_id, meta: pagination_dict(likes)
  end

  def create
    like = @post.likes.build(user: current_user)
    if like.save
      render json: like, status: 201
    else
      render json: { errors: like.errors }, status: 422
    end
  end

  def destroy
    like = @post.likes.find_by!(user: current_user)
    like.destroy
    head 204
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

end
