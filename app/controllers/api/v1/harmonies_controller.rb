class Api::V1::HarmoniesController < ApplicationController

  def index
    harmonies = Harmony.where(nil).page(params[:page]).per(params[:limit])
    harmonies = harmonies.where(line_id: params[:line_id]).page(params[:page]).per(params[:limit]) if params[:line_id]
    render json: harmonies, meta: pagination_dict(harmonies)
  end
end
