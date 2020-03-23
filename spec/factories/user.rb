FactoryBot.define do
  factory :user do
    email { 'test@test.com' }
    account_id { 'testtest' }
    name { 'tester' }
    password { 'password123' }
  end
end
