# frozen_string_literal: true

module PostRefer
  class AwardCommissionAndReferHistoryService
    attr_accessor :cart, :order_detail
    def initialize(cart, order_detail)
      @cart = cart
      @order_detail = order_detail
    end

    def call
      return unless cart.cart_unique_codes.present?
      cart.cart_unique_codes.each do |cart_unique_code|
        refer = Refer.find_by(unique_code: cart_unique_code.unique_code)
        next unless refer.present?
        unique_code_used = Order
                               .joins(:order_unique_codes)
                               .where.not(orders: { id: order_detail.order_id })
                               .where(orders: { user_id: cart&.user_id},
                                      order_unique_codes: { refer_id: refer.id }).any?
        next if unique_code_used
        create_refer_history(refer)
        reward_wallet_commission(refer)
        order_detail.order.order_unique_codes.find_or_create_by(refer_id: refer.id)
      end
    end

    private

    def create_refer_history(refer)
      refer.refer_histories.find_or_create_by(user_id: cart.user_id)
      refer.increment(:refer_counts)
    end

    def reward_wallet_commission(refer)
      post_creator = refer.user
      wallet_commission_list =
        WalletCommissionList.create(order_detail_id: order_detail.id, user_id: post_creator&.id,
                                     commission_amount: (order_detail.price * WalletCommissionList.commission_percentage)/100) if post_creator.id != cart.user_id
      wallet_amount = post_creator.wallet&.amount || 0
      post_creator.wallet.update(amount: wallet_amount +  wallet_commission_list.commission_amount)
    end
  end
end
