FactoryBot.define do
  factory :message do
    body "MyText"
    association :conversation
    association :user
    association :post
    read false
  end
end
