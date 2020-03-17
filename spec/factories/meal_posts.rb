FactoryBot.define do
  factory :meal_post do
    content { 'meal post content' }
    time { '2016/04/14 21:45:22' }
    association :user
  end
end
