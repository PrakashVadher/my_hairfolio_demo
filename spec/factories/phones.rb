FactoryBot.define do
  factory :phone do
    number { Faker::PhoneNumber.phone_number}
    phone_type 'home'
    association :contact
  end
end
