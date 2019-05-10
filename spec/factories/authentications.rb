FactoryBot.define do
  factory :authentication do
    association :provider
    association :user
    uid "MyString"
    token "MyString"
    token_expires_at "2016-12-06 13:37:01"
    username "MyString"
    params "MyText"
  end
end
