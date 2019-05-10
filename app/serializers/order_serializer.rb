class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :charge_id, :order_number, :payment_status,
             :shipping_status, :amount, :wallet_amount, :coupon_amount, :final_amount,
             :created_at, :discount
  belongs_to :address
  has_many :order_details
  has_one :payment_transaction

  def created_at
    object.created_at.iso8601
  end
end
