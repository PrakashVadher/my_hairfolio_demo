FactoryBot.define do
  factory :order do
    user_id { 1 }
    transaction_id { "MyString" }
    charge_id { "MyString" }
  end
end
