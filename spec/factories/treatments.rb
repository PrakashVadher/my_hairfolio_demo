FactoryBot.define do
  factory :treatment do
    association :color
    association :formula
    weight 1
  end
end
