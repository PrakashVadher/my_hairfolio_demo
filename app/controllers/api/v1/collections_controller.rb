class Api::V1::CollectionsController < ApplicationController
  before_action :authenticate_with_token!, except: [:index]

  def index
    success(data: Collection.all, status: 200)
  end
end

