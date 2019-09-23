require 'rails_helper'

RSpec.feature "Users", type: :system do

  def goto_image
    visit root_path
    click_link "画像編集"
  end

  scenario "ユーザのファクトリでファイルを添付する" do
    user = FactoryBot.create(:user, :with_image)
    expect(user).to be_truthy
    expect(user.image).to be_truthy
    
  end


  scenario "ユーザーが添付ファイルをアップロードする" do
    user = FactoryBot.create(:user, :with_tasks)

    sign_in user
    goto_image
    expect(page).to_not have_css('main img')
    attach_file "user_image", "#{Rails.root}/spec/files/attachment.jpg"
    click_button "更新する"
    aggregate_failures do
      expect(page).to have_content "画像をアップロードしました。"
      expect(page).to have_css('main img')
    end
  end

end
