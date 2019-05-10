FactoryBot.define do
  factory :line do
    name { Faker::Company.name }
    association :brand
    unit "g"
  end
end
