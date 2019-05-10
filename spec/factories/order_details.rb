FactoryBot.define do
  factory :order_detail do
    order_id { 1 }
    product_id { 1 }
    quantity { 1 }
    price { "" }
  end
end
