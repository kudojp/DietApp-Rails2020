FactoryBot.define do
  factory :relationship do
    association :follower, factory: :user
    association :followed, factory: :user, email: 'another@test.com', account_id: 'another'
  end
end
