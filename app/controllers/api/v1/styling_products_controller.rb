class Api::V1::StylingProductsController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: StylingProduct.all, status: 200)
  end
end

