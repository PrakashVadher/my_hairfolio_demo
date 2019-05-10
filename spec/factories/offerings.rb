FactoryBot.define do
  factory :offering do
    association :user
    association :category
    association :service
    price 1
  end
end
