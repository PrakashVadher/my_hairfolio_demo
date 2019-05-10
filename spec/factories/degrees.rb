FactoryBot.define do
  factory :degree do
    name { Faker::Commerce.product_name }
    postion 1
  end
end
