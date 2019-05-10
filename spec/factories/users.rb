FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password "testing123"
    account_type 'consumer'
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    avatar_url { Faker::Avatar.image }
    avatar_cloudinary_id { rand(0..1822)}
    prof_desc { Faker::Lorem.paragraph }
    years_exp { rand(0..20)}
    career_opportunity { Faker::Lorem.paragraph }
  end
end
