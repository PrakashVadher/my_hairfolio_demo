class Api::V1::SearchesController < ApplicationController
  before_action :check_user
  PRELOAD_ARRAY = %i[product_galleries product_brand tag categories favourites hair_types
                    consistency_types ingredients styling_tools preferences product_types
                    shampoo conditioner collection styling_product]
  def search_products
    @products = Product.where(nil)
    @products = @products.where('lower(name) LIKE ? or lower(description) LIKE ?', "%#{params[:search].downcase}%", "%#{params[:search].downcase}%") if params[:search].present?
    @products = @products.page(params[:page]).per(params[:limit]).order('id DESC')

    render json: @products, meta: pagination_dict(@products)
  end

  def filter_products
    products = Product.all
    products = products.search(params[:search]) if params[:search].present?
    products = Product.filter(products, params).distinct
    products = products.page(params[:page]).per(params[:limit]).order('products.id DESC')
    render json: products, user_id: @user_id, meta: pagination_dict(products)
  end

  def product_brands
    @product_brands = ProductBrand.all
    @product_brands = @product_brands.page(params[:page]).per(params[:limit]).order('id DESC')
    render json: @product_brands, meta: pagination_dict(@product_brands)
  end
end
