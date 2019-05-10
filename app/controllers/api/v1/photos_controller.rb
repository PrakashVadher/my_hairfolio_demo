class Api::V1::PhotosController < ApplicationController

  def update
    photo = Photo.find(params[:id])
    if photo.valid?
      photo.labels.destroy_all
    end
    if photo.update(photo_params)
      render json: photo, status: 201
    else
      render json: { errors: photo.errors }, status: 422
    end
  end

  private

  def photo_params
    params.require(:photo).permit(:asset_url, :video_url, :post_id, labels_attributes: [:id, :_destroy, :post_id, :tag_id, :label_type, :position_top, :position_left, :name, :url, formulas_attributes: [:id, :_destroy, :service_id, :line_id, :time, :weight, :volume, :position_top, :position_left, :post_id, treatments_attributes: [:color_id, :weight, :id, :_destroy]]])
  end

end
