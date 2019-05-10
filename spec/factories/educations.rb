FactoryBot.define do
  factory :education do
    name { Faker::Company.name }
    year_from 1998
    year_to 1288
    association :degree
    association :user
    website { Faker::Internet.url }
  end
end
