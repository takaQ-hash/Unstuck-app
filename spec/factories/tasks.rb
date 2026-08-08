FactoryBot.define do
  factory :task do
    user { nil }
    name { "MyString" }
    deadline { "2026-08-08" }
    notification_type { 1 }
    notification_value { "MyString" }
  end
end
