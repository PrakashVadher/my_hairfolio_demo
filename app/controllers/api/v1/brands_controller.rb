class Api::V1::BrandsController < ApplicationController  
  before_action :check_user
 
  def index
    brands =
      if params["service_id"]
        Service.find(params[:service_id]).brands
      else
        Brand.all
      end
    all_brands =  brands.page(params[:page]).per(params[:limit])
    render json: all_brands, includes: [:services], meta: pagination_dict(all_brands)
  end

  def show
    render json: Brand.find(params[:id])
  end

  #Post Apis  
  def all_posts
      posts = Post.all
      posts = posts.order(updated_at: :desc).page(params[:page]).per(params[:limit])    
      render json: posts, user_id: @user_id, meta: pagination_dict(posts)
  end

  def trendings
    @posts = Post.where(is_trending: true).paginate(pagination_params)
    render json: @posts, user_id: @user_id, meta: pagination_dict(@posts)
  end

  def editor_pics
    @posts = Post.where(is_editors_pic: true)
    render json: @posts, user_id: @user_id
  end

end
