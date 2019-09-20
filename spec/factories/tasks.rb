FactoryBot.define do
  factory :task do
    sequence(:content) { |n| "Test#{n} Content" }
    association :user
    # 締め切りは一週間後
    due_on { 1.week.from_now }

    # 無効な属性値
    trait :invalid do
      content { nil }
    end

    # 締め切りが昨日
    trait :due_yesterday do
      due_on { 1.day.ago }
    end
    # 締め切りが今日
    trait :due_today do
      due_on { Date.current.in_time_zone }
    end
    # 締め切りが明日
    trait :due_tomorrow do
      due_on { 1.day.from_now }
    end
  end
end
