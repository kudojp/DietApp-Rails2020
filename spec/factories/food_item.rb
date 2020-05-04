FactoryBot.define do
  factory :food_item do
    name { Faker::Food.dish }
    amount { Faker::Lorem.word }
    calory { Faker::Number.within(range: 1..1000) }
  end
end
