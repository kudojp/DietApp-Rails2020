FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    account_id { Faker::Alphanumeric.unique.alpha(number: 5) }
    name { Faker::Alphanumeric.unique.alpha(number: 5) }
    password { 'password123' }
  end
end
