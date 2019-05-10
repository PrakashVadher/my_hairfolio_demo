FactoryBot.define do
  factory :color do
    association :harmony
    code "jdij2d390"
    start_hex { Faker::Color.hex_color.gsub('#','') }
    end_hex  { Faker::Color.hex_color.gsub('#','') }
  end
end
