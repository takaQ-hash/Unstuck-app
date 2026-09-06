FactoryBot.define do
  factory :push_subscription do
    user { nil }
    endpoint { "MyString" }
    p256dh { "MyString" }
    auth { "MyString" }
  end
end
