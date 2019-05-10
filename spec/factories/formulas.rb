FactoryBot.define do
  factory :formula do
    association :label
    association :service
    weight 1
    volume 1
    time 1
    position_top 1
    position_left 1

    after :create do |formula|
      create(:treatment, formula: formula)
    end
  end
end
