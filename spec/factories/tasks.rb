FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task_#{n}" }
    deadline { "2026-08-08" }
    notification_type { :interval }
    notification_value { "120" }
    association :user
  end
end
