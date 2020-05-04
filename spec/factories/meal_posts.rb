FactoryBot.define do
  factory :meal_post do
    content { Faker::Lorem.words }
    time { Faker::Time.between(from: DateTime.now - 10.years, to: DateTime.now) }
    user
    after(:build) do |this_meal_post|
      this_meal_post.food_items << build(:food_item, meal_post: this_meal_post)
    end
  end
end
