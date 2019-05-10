FactoryBot.define do
  factory :harmony do
    association :line
    name { Faker::Company.name }
    position 1
  end
end
