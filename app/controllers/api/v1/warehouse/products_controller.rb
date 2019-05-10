class Api::V1::Warehouse::ProductsController < ApplicationController
  PRELOAD_ARRAY = %i[product_galleries product_brand tag categories favourites hair_types
                    consistency_types ingredients styling_tools preferences product_types
                    shampoo conditioner collection styling_product]
  before_action :authenticate_with_token!
  before_action :authorize_warehouse_user
  before_action :set_product, only: %i[show update destroy]

  def index
    products = Product.includes(PRELOAD_ARRAY)
                      .search(params[:q])
                      .order(created_at: :desc)
                      .paginate(pagination_params)
    success(data: products, meta: pagination_dict(products), status: 200)
  end

  def create
    Product.create!(product_params)
    success(data: { message: I18n.t('products.create')}, status: 200)
  end

  def show
    # render json: @product, append_related_products: true, status: 200
    success(data: @product, status: 200, serializer_options: { append_related_products: true })
  end

  def update
    @product.update!(product_update_params)
    success(data: { message: I18n.t('products.update') }, status: 200)
  end

  def destroy
    @product.destroy!
    success(data: { message: I18n.t('products.destroy') }, status: 200)
  end


  private

  def product_params
    params.require(:product).permit(:name, :tag_id, :price, :quantity,
                                    :description, :short_description,
                                    :image_url, :link_url, :cloudinary_url,
                                    :product_brand_id, :is_trending, :new_arrival,
                                    :product_image,
                                    :shampoo_id,
                                    :conditioner_id,
                                    :collection_id,
                                    :styling_product_id,
                                    product_galleries_attributes: [:image_url],
                                    category_ids: [],
                                    product_type_ids: [],
                                    hair_type_ids: [],
                                    ingredient_ids: [],
                                    preference_ids: [],
                                    consistency_type_ids: [],
                                    styling_tool_ids: [],
                                    related_product_ids: [])
  end

  def product_update_params
    params.require(:product)
          .permit(:name, :tag_id, :price, :quantity,
                  :description, :short_description,
                  :image_url, :link_url, :cloudinary_url,
                  :product_brand_id, :is_trending, :new_arrival,
                  :product_image,
                  :shampoo_id,
                  :conditioner_id,
                  :collection_id,
                  :styling_product_id,
                  product_galleries_attributes: [:id, :image_url, :_destroy],
                  category_ids: [],
                  product_type_ids: [],
                  hair_type_ids: [],
                  ingredient_ids: [],
                  preference_ids: [],
                  consistency_type_ids: [],
                  styling_tool_ids: [],
                  related_product_ids: [])
  end

  def authorize_warehouse_user
    authorize Product
  end

  def set_product
    @product = Product.includes(:related_products).find(params[:id])
  end
end