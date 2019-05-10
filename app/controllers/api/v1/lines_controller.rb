class Api::V1::LinesController < ApplicationController

  def index
    lines = Line.where(nil).page(params[:page]).per(params[:limit])
    lines = lines.where(brand_id: params[:brand_id]).page(params[:page]).per(params[:limit]) if params[:brand_id]
    render json: lines, meta: pagination_dict(lines)
  end

end
