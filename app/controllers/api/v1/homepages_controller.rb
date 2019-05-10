class Api::V1::HomepagesController < ApplicationController
	before_action :check_user
  def index
    #homepages  = Homepage.active
    homepages  = Homepage.where(status: :active).order(created_at: :ASC)
    #likes_count
    #homepages = homepages.page(params[:page]).per(params[:limit])
    #, meta: pagination_dict(homepages)
    #success(data: homepages, user_id: @user_id, status: 200)
    render json: homepages, user_id: @user_id
  end

  def home_trending_and_editor_posts
    id = params[:id]
    homepages  = Homepage.find(id).posts.order(created_at: :ASC).paginate(pagination_params)
    render json: homepages, user_id: @user_id, meta: pagination_dict(homepages)
  end
end