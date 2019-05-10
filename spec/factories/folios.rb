FactoryBot.define do
  factory :folio do
    association :user
    name { Faker::Lorem.sentence }
  end
end
