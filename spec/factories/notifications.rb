FactoryBot.define do
  factory :notification do
    association :user
    body { Faker::Lorem.paragraph }
    association :notifiable, factory: :follow
  end
end
