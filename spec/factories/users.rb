FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "pass123" }
    confirmed_at { 1.day.ago } # ログインには確認済みの日にちが必要

    trait :with_tasks do
      after(:create) { |user| create_list(:task, 5, user: user) }
    end

    trait :with_image do
      after(:build) do |user|
        user.image = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'attachment.jpg'), 'image/jpg')
      end      
    end
  end
end
