class Api::V1::ConsistencyTypesController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: ConsistencyType.all, status: 200)
  end
end

