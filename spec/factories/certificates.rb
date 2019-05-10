FactoryBot.define do
  factory :certificate do
    name { Faker::Commerce.product_name }
    position 1
  end
end
