FactoryBot.define do
  factory :report do
    status { :in_progress }
    sequence(:memo) { |n| "報告_#{n}" }
    association :task
  end
end
