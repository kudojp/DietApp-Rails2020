FactoryBot.define do
  factory :meal_post do
    content { Faker::Lorem.words }
    time { Faker::Time.between(from: DateTime.now - 10.years, to: DateTime.now) }
    user
  end
end
