class Api::V1::CategoriesController < ApplicationController
  # before_action :set_category, only: [:show]
  def index
    user_id = User.where(auth_token:request.headers['Authorization']).map(&:id) 
    categories = Category.where(ancestry: nil).order('id DESC').page(params[:page]).per(params[:limit])       
    render json: categories, user_id: user_id[0], meta: pagination_dict(categories)
  end

  def show
    @category = Category.find(params[:id])    
    render json: @category
  end

  def search_by_categories
    @categories = Category.order('id DESC').find(params[:category_ids])
    @categories.each do |category|
      @products = category.products
    end
    render json: @products
  end

end
