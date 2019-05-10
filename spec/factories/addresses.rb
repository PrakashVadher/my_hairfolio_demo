FactoryBot.define do
  factory :address do
    user_id { 1 }
    email { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    address { "MyText" }
    phone { "MyString" }
    city { "MyString" }
    landmark { "MyString" }
    zip_code { "MyString" }
    default_address { false }
  end
end
