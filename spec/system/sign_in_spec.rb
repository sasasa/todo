require 'rails_helper'

RSpec.feature "Sign In", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  scenario "ユーザのログイン時に非同期キューが登録される" do
    visit root_path
    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: user.password
    click_button "ログイン"
    expect {
      GeocodeUserJob.perform_later(user)
    }.to have_enqueued_job.with(user)
  end
end
