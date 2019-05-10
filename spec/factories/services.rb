FactoryBot.define do
  factory :service do
    name { Faker::Company.name }
    position 1
  end
end
