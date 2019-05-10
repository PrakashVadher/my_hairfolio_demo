FactoryBot.define do
  factory :video do
    asset_url { Faker::Internet.url }
    association :post
  end
end
