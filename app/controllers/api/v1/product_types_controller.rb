class Api::V1::ProductTypesController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: ProductType.all, status: 200)
  end
end

