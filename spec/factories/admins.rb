FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "pass123" }
    confirmed_at { 1.day.ago } # ログインには確認済みの日にちが必要

  end
end
