FactoryBot.define do
  factory :label do
    association :tag
    association :photo
    position_top 1
    position_left 1
    name { Faker::Company.name }
    url { Faker::Internet.url }
  end
end
