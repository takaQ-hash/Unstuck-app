FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user_#{n}" } 
    sequence(:email) { |n| "test#{n}@sample.com" } 
    password { "MyString" }
  end
end
