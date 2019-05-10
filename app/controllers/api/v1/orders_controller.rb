# frozen_string_literal: true

class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_with_token!

  def index
    # orders = Order.where(user_id: current_user.id)    
    # orders = orders.where(shipping_status: "progress").or(orders.where(shipping_status: "pending")) if params[:status] == "pending"
    # orders = orders.where(shipping_status: "delivered") if params[:status] == "delivered"    
    # orders = orders.order('id asc')
    raise ActionController::ParameterMissing.new(:status) unless %w[pending delivered].include? params.dig(:status)    
    status = params[:status] == "pending" ? %i[pending progress] : params[:status]
    orders = @current_user.orders.where(shipping_status: status).order('created_at desc')
    orders = orders.page(params[:page]).per(params[:limit])

    render json: orders, meta: pagination_dict(orders)
  end

  def create
    resp =
      Orders::CreationService.new(
        current_user: @current_user,
        address_params: order_address_params,
        payment_params: params[:payment_params],
        wallet_params: params[:wallet_params],
        coupon_params: params[:coupon_params],
        unique_code_params: params[:unique_code_params]
      ).call
    if resp.success?
      success(data: resp.data, status: 200)
    else
      if resp.code == 'not_found'
        errors(message: resp.message, status: 404)
      else
        errors(message: 'error', status: 422)
      end
    end
  end

  def show
    @order = Order.find(params[:id])
    render json: @order, status: 200
  end

  private

  def order_address_params
    params.require(:address_params).permit(:address_id)
  end
end
