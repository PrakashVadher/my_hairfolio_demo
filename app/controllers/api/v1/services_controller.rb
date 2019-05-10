class Api::V1::ServicesController < ApplicationController

  def index
    services = Service.where(nil).page(params[:page]).per(params[:limit])
    services = Brand.find(params[:brand_id]).services.page(params[:page]).per(params[:limit]) if params["brand_id"]
    render json: services, meta: pagination_dict(services)
  end

  def show
    render json: Service.find(params[:id])
  end

end
