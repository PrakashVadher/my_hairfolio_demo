class Api::V1::IngredientsController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: Ingredient.all, status: 200)
  end
end

