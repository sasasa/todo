require 'rails_helper'

RSpec.feature "Sign Up", type: :system do
  include ActiveJob::TestHelper

  scenario "ユーザはサインアップに成功する" do
    visit root_path
    click_link "サインアップ"
    perform_enqueued_jobs do
      expect {
        fill_in "メールアドレス", with: "test@example.com"
        fill_in "パスワード", with: "test123"
        fill_in "確認用パスワード", with: "test123"
        click_button "サインアップ"
      }.to change(User, :count).by(1)
      expect(page).to have_content "ログイン"
      expect(current_path).to eq "/users/sign_in"
    end

    mail = ActionMailer::Base.deliveries.last
    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      # expect(mail.from).to eq ["support@example.com"]
      expect(mail.subject).to eq "メールアドレス確認メール"
      expect(mail.body).to match "test@example.com"
    end
  end
end
