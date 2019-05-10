class Api::V1::PostsController < ApplicationController
  
  before_action :authenticate_with_token!, only: [:create, :update, :destroy, :index, :user_posts]
  before_action :set_post, only: [:update, :destroy, :show, :stylist_other_posts]
  before_action :check_user
  
  def index
    #binding.pry
    #This condition user for mobile app issue 08-05-2019
    get_like_user = params[:user_id]
    if get_like_user.nil? || get_like_user == 0
      posts = Post.where(nil)
      posts = posts.where("description ilike ?", "%#{params[:q]}%") if params[:q]
      posts = posts.where(user: current_user.following + User.where(id: current_user.id)).order('created_at desc') unless (params[:popular] || params[:favorites])
      posts = posts.popular if params[:popular]
      posts = posts.favorites(current_user).order('created_at desc') if params[:favorites]
      posts = posts.where.not(user_id: current_user.blocking.pluck(:id))
      if params[:favorites]
        posts = posts.page(params[:page]).per(params[:favorites] ? 6 : 4)
      else
        #posts = posts.page(params[:page]).per(5)
        posts = posts.paginate(pagination_params)
      end
      render json: posts, user_id: @user_id, meta: pagination_dict(posts)
    else
      likes = Like.where(user_id: params[:user_id])
      likes = likes.page(params[:page]).per(6)
      render json: likes, user_id: @user_id, meta: pagination_dict(likes)
    end
  end

  def user_posts
      posts = Post.where(user_id:current_user.id).order('id desc')
      posts = posts.page(params[:page]).per(params[:limit])

      render json: posts,user_id: @user_id, meta:pagination_dict(posts)
  end

  def hashtag_posts
    posts = PostsQuery.new.by_tags(params[:tag_ids])
    related_posts = PostsQuery.new(posts).related_posts
    # related_posts = PostsQuery.new.by_tags(TagsQuery.new(Tag.where(id: params[:tag_ids])).related_tags)
    # result = Post.union(posts, related_posts).paginate(pagination_params)
    result = posts.merge(related_posts.distinct)
    result = result.where.not(id: User.unscoped.find(@user_id).blocking_posts) if @user_id.present?
    result = result.paginate(pagination_params)
    render json: result, user_id: @user_id, meta: pagination_dict(result)
  end

  # def search_by_tags
  #   tag_ids = params[:term].present? ? Tag.search(params[:term]).select(:id) : []
  #   posts = PostsQuery.new.by_tags(tag_ids)
  #   posts = posts.where.not(id: User.unscoped.find(@user_id).blocking_posts) if @user_id.present?
  #   posts = posts.paginate(pagination_params)
  #   render json: posts, user_id: @user_id, meta: pagination_dict(posts)
  # end

  def search_by_tags
      tag_ids = params[:term].present? ? Tag.search(params[:term]).select(:id) : []
      posts = PostsQuery.new.by_tags(tag_ids)
      related_posts = PostsQuery.new(posts).related_posts
      posts = posts.merge(related_posts.distinct)
      posts = posts.where.not(id: User.unscoped.find(@user_id).blocking_posts) if @user_id.present?
      posts = posts.paginate(pagination_params)
      render json: posts, user_id: @user_id, meta: pagination_dict(posts)
    end
  def create

    post = current_user.posts.build(post_params)
    if post.save
      render json: post, status: 201
    else
      render json: { errors: post.errors }, status: 422
    end
  end

  def update
    if @post.update(post_params)
      render json: @post, status: 201
    else
      render json: { errors: @post.errors }, status: 422
    end
  end

  def posts_by_tag
    @posts = Post.joins(photos: :tags).where(tags: { id: params[:tag_id] } )
    @posts = @posts.page(params[:page]).per(params[:limit])
    
    render json: @posts, user_id: @user_id, meta: pagination_dict(@posts)
  end

  def show
    render json: @post, user_id: @user_id, root: 'post'
  end

  def destroy
    @post.destroy
    head 204
  end

  def stylist_other_posts
    stylist = @post.user
    posts = stylist.posts.where.not(id: @post.id).order(created_at: :desc).paginate(pagination_params)
    render json: posts, user_id: @user_id, meta: pagination_dict(posts)
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:description, product_ids:[], videos_attributes: [:id, :_destroy, :asset_url, :post_id, :video_url], photos_attributes: [:asset_url, :video_url, :id, :_destroy, labels_attributes: [:id, :_destroy, :post_id, :product_id, :tag_id, :label_type, :position_top, :position_left, :name, :url, formulas_attributes: [:id, :_destroy, :service_id, :line_id, :time, :weight, :volume, :position_top, :position_left, :post_id, treatments_attributes: [:color_id, :weight, :id, :_destroy]]]])
  end

end
