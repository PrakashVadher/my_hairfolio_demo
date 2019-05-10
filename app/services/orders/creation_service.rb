module Orders
  class CreationService
    attr_accessor :current_user, :address, :payment_params, :order, :address_params, :post_unique_code,
                  :transaction, :wallet_params, :coupon_params, :card, :coupon, :wallet
    def initialize(current_user:, address_params:, payment_params:, wallet_params: {}, coupon_params: {},unique_code_params: {})
      @current_user = current_user
      @address_params = address_params
      @payment_params = payment_params
      @wallet_params = wallet_params
      @coupon_params = coupon_params
      @post_unique_code = unique_code_params&.dig(:unique_code)
    end

    def call
      raise Errors::CartEmptyError if current_user.carts.empty?
      return ErrorResponse.new(message: [I18n.t('address.not_found')], code: 'not_found') unless valid_address?
      return ErrorResponse.new(message: [I18n.t('coupons.not_found')], code: 'not_found') unless valid_coupon?

      errors = nil
      ActiveRecord::Base.transaction do
        create_order_and_apply_commissions
        create_transaction
        unless valid_card?
          errors = ErrorResponse.new(message: [I18n.t('cards.not_found')], code: 'not_found')
          raise ActiveRecord::Rollback
        end
        create_payment
        send_notification
        # reward_commission_to_post_creator if @post_unique_code
      end
      return errors if errors

      SuccessResponse.new(data: order)
    end

    private

    def valid_address?
      current_user.addresses.find_by(id: address_params[:address_id]).present?
    end

    def valid_coupon?
      return true unless coupon_params&.dig(:coupon_id)

      @coupon = current_user.referrer_coupons.find_by(id: coupon_params.dig(:coupon_id))
      @coupon.present?
    end

    def valid_card?
      return true unless order.final_amount.positive?

      @card = current_user.cards.find_by(id: payment_params&.dig(:card_id))
      @card.present?
    end

    def create_order_and_apply_commissions
      create_order_and_order_details
      apply_coupon
      apply_wallet_amount if wallet_params&.dig(:use_wallet_money)
      order.save!
      wallet.save! if wallet
    end

    def create_order_and_order_details
      @order =
        current_user.orders.create!(payment_status: 'awaiting', order_number: "Ord#{DateTime.now.strftime("%Y%m%d%H%M%S%L")}",
                                    shipping_status: 'pending', address_id: address_params[:address_id])
      price = 0
      cart_data = current_user.carts
      cart_data.each do |cart|
        current_quantity = cart.product.quantity
        raise Errors::QuantityExceedError if current_quantity < cart.quantity
        cart.product.update!(quantity: current_quantity - cart.quantity)
        order_detail =
          order.order_details.create!( product_id: cart.product_id,
                                       quantity: cart.quantity,
                                       price: cart.product.final_price*cart.quantity,
                                       discount: (cart.product.price * cart.quantity * (cart.product.discount_percentage || 0))/100
          )
        price += (cart.product.price * cart.quantity)
        PostRefer::AwardCommissionAndReferHistoryService.new(cart, order_detail).call
        cart.destroy!
      end
      final_price = order.order_details&.pluck(:price)&.sum
      order.update!(amount: price.to_f, final_amount: final_price, discount: price - final_price)
      order
    end

    def apply_coupon
      if coupon
        order.coupon_amount = (order.final_amount * coupon.discount_percentage) / 100
        order.final_amount -= (order.final_amount * coupon.discount_percentage) / 100
        coupon.destroy!
      end
    end

    def apply_wallet_amount
      @wallet = current_user.wallet
      return unless wallet
      return if wallet.amount.zero?
      if wallet.amount > order.final_amount
        order.wallet_amount = order.final_amount
        wallet.amount -= order.final_amount
        order.final_amount = 0
      else
        order.wallet_amount = wallet.amount
        order.final_amount -= wallet.amount
        wallet.amount = 0
      end
    end

    def create_transaction
      @transaction =
        order.create_payment_transaction!(amount: order.final_amount, user_id: current_user.id,
                                          transaction_type: :debit)
    end

    def create_payment
      order.update!(payment_status: 'paid')
      return unless order.final_amount > 0
      payment = Payments::CreationService.new(order: order, card: card).call
      transaction.update!(stripe_charge_id: payment['id'])
    end

    def send_notification
      notification = Notifications::OrderNotification.new(order: order, for_activity: 'order_created').generate
      ApplicationNotification.new(notification: notification).deliver if notification
    end

    def reward_commission_to_post_creator
      PostRefer::AwardCommissionService.new(order: order, post_uniq_code: post_unique_code).call
    end
    
  end
end