class Api::V1::ConditionersController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: Conditioner.all, status: 200)
  end
end

