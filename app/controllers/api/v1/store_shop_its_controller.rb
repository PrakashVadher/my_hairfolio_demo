class Api::V1::StoreShopItsController < ApplicationController
  
  def index
    @shop_it = StoreShopIt.all.limit 1    
    render json: @shop_it
  end

end
