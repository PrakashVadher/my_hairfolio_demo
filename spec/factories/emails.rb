FactoryBot.define do
  factory :email do
    email { Faker::Internet.email }
    email_type 'primary'
    association :contact
  end
end
