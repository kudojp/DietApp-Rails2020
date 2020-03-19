FactoryBot.define do
  factory :vote do
    user_id { 1 }
    meal_post_id { 1 }
    is_upvote { true }
  end
end
