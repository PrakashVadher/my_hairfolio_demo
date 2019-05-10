class Api::V1::StoreLandingSalesController < ApplicationController
  
  def index
    @sale = StoreLandingSale.all.limit 1    
    render json: @sale
  end

end
