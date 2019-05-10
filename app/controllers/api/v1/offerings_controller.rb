class Api::V1::OfferingsController < ApplicationController
  before_action :authenticate_with_token!
  before_action :set_user
  before_action :set_offering, only: [:show, :update, :destroy]

  def index
    offerings = @user.offerings.page(params[:page]).per(params[:limit])
    render json: offerings, meta: pagination_dict(offerings)
  end

  def show
    render json: @offering
  end

  def update
    if @offering.update(offering_params)
      render json: @offering, status: 201
    else
      render json: { errors: @offering.errors }, status: 422
    end
  end

  def create
    offering = @user.offerings.build(offering_params)
    if offering.save
      render json: offering, status: 201
    else
      render json: { errors: offering.errors }, status: 422
    end
  end

  def destroy
    @offering.destroy
    head 204
  end

  private

  def offering_params
    params.require(:offering).permit(:user_id, :category_id, :service_id, :price)
  end

  def set_offering
    @offering = @user.offerings.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
