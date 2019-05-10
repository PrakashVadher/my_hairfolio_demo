class Api::V1::FavouritesController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_product

  def index
    favourites = @product.favourites.page(params[:page]).per(params[:limit])    
    render json: favourites, meta: pagination_dict(favourites)
  end

  def create
    favourite = @product.favourites.build(user: current_user)
    if favourite.save
      render json: favourite, status: 201
    else
      render json: { errors: favourite.errors }, status: 422
    end
  end

  def destroy
    favourite = @product.favourites.find_by!(user: current_user)    
    favourite.destroy
    render json: favourite, status:201    
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

end
