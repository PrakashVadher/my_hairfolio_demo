class Api::V1::HairTypesController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: HairType.all, status: 200)
  end
end

