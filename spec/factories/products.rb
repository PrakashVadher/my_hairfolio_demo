FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    association :tag
    image_url { Faker::Avatar.image }
    link_url { Faker::Internet.url }
  end
end
