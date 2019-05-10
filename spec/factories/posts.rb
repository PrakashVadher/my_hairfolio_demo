FactoryBot.define do
  factory :post do
    association :user
    description { Faker::Lorem.paragraph }
  end
end
