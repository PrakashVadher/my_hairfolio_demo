class Api::V1::ShampoosController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: Shampoo.all, status: 200)
  end
end

