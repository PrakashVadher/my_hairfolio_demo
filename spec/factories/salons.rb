FactoryBot.define do
  factory :salon do
    name  { Faker::Company.name }
    info { Faker::Lorem.paragraph }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.postcode }
    website { Faker::Internet.url }
    phone { Faker::PhoneNumber.phone_number }
    after :create do |s|
      create(:user, account_type: 'owner', salon: s)
    end
  end
end
