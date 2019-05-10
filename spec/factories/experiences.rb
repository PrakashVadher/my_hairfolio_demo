FactoryBot.define do
  factory :experience do
    name { Faker::Company.name }
    position 1
  end
end
