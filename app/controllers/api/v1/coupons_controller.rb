class Api::V1::CouponsController < ApplicationController
  before_action :authenticate_with_token!

  def index
    coupons = @current_user.referrer_coupons.order(created_at: :desc).paginate(pagination_params)
    success(data: coupons, status: 200, meta: pagination_dict(coupons))
  end
end
