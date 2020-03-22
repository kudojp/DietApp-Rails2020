FactoryBot.define do
  factory :vote do
    user
    meal_post
    is_upvote { true }
  end
end
