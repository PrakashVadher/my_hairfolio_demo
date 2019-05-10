FactoryBot.define do
  factory :contact do
    association :user
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    company { Faker::Company.name }
    address { Faker::Address.street_address }

    after :create do |contact|
      create(:email, contact: contact)
      create(:phone, contact: contact)
    end
  end
end
