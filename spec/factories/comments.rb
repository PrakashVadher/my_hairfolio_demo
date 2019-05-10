FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { Faker::Lorem.paragraph }
  end
end
