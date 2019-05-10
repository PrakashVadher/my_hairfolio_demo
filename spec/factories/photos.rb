FactoryBot.define do
  factory :photo do
    asset_url { Faker::Internet.url }
    association :post
  end
end
