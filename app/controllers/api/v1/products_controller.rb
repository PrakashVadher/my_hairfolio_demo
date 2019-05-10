class Api::V1::ProductsController < ApplicationController
  before_action :check_user
  before_action :set_product, only: %i[show related_products]
  before_action :authenticate_with_token!, only: :all_products

  def index
    products = Product.where(nil)
    products = products.where("products.name ilike ?", "%#{params[:q]}%")
    products = Product.filter(products, params)
    products = products.order('products.id DESC').page(params[:page]).per(params[:limit])
    render json: products, user_id: @user_id, meta: pagination_dict(products)
  end

  def show
    render json: @product, user_id: @user_id, options: { append_related_products: true }
  end

  def trending_products
    trending_products = Product.where(is_trending: true).order(created_at: :desc)
    render json: trending_products, user_id: @user_id
  end

  def newarrival_products
    products = Product.where(new_arrival: true).order(created_at: :desc)
    products = products.page(params[:page]).per(params[:limit])
    render json: products, user_id: @user_id, meta: pagination_dict(products)
  end

  def related_products
    related_products = @product.related_products.paginate(pagination_params)
    success(data: related_products, meta: pagination_dict(related_products), status: 200)
  end

  def all_products
    products = Product.select(:id, :name)
    products = products.where('name ilike ?', "%#{params[:q]}%") if params[:q].present?
    render json: products, each_serializer: ProductMinimalSerializer
  end

  private

  def set_product
    @product = Product.includes(:related_products).find(params[:id])
  end

end
