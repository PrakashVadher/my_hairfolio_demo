# frozen_string_literal: true

module PostRefer
  class AwardCommissionService
    attr_accessor :refer, :order
    def initialize(post_uniq_code:, order:)
      @refer = Refer.find_by(unique_code: post_uniq_code)
      @order = order
    end

    def call
      return unless refer
      product_purchase_from_post = refer.post.product_ids & order.order_details.pluck(:product_id)
      return if product_purchase_from_post.empty?
      wallet_commission_array = []
      product_purchase_from_post.each do |product_id|
        order_detail = order.order_details.find_by(product_id: product_id)
        wallet_commission_array << { order_detail_id: order_detail.id,
                                     commission_amount: (order_detail.price * WalletCommissionList.commission_percentage)/100}
      end
      post_creator = refer.post.user
      post_creator.wallet_commission_lists.create(wallet_commission_array)
      wallet_amount = post_creator.wallet.amount
      post_creator.wallet.update(amount: wallet_amount + wallet_commission_array.sum { |h| h[:commission_amount] })

      ReferHistory.find_or_create_by(user_id: order.user_id, refer_id: refer.id)
      refer.increment(:refer_counts)
    end
  end
end