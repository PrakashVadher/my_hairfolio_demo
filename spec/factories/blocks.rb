FactoryBot.define do
  factory :block do
    association :blocker, factory: :user
    association :blocking, factory: :user
  end
end
