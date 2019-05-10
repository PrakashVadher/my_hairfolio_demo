FactoryBot.define do
  factory :category do
    name { Faker::Company.name }
    position 1
  end
end
