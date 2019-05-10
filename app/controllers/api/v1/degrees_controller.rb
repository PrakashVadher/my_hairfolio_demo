class Api::V1::DegreesController < ApplicationController

  def index
    degrees = Degree.all.order('position asc').page(params[:page]).per(params[:limit])
    render json: degrees, meta: pagination_dict(degrees)
  end

  def show
    render json: Degree.find(params[:id])
  end
end
