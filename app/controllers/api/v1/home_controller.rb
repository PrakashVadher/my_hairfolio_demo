class Api::V1::HomeController < ApplicationController
  def index
    render json: { message: "Welcome!" }
  end

end
