class Api::V1::Delivery::OrdersController < ApplicationController
  before_action :authenticate_with_token!
  before_action :authorize_delivery_user
  before_action :set_order, only: %i[show update]

  def index
    params[:status] = params[:status] == 'pending' ? %i[pending progress] : params[:status]
    status = params[:status] || Order.shipping_statuses.keys
    @orders = @current_user.delivery_orders.search(params[:q]).where(shipping_status: status)
                  .order(created_at: :desc).paginate(pagination_params)
    success(data: @orders, status: 200, meta: pagination_dict(@orders))
  end

  def show
    success(data: @order, status: 200)
  end

  def update
    raise ActionController::ParameterMissing.new(:shipping_status) unless %w[progress delivered].include? params.dig(:order, :shipping_status)
    @order.update!(order_update_params)
    success(data: { message: I18n.t('orders.update') }, status: 200)
  end

  private

  def authorize_delivery_user
    authorize Order
  end

  def set_order
    @order = @current_user.delivery_orders.find(params[:id])
  end

  def order_update_params
    params.require(:order).permit(:shipping_status)
  end
end