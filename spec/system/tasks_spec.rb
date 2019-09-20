require 'rails_helper'

RSpec.feature "Tasks", type: :system do
  include ActiveJob::TestHelper # perform_enqueued_jobsが使える

  def goto_update_task(task_content)
    visit root_path
    expect(page).to have_content task_content
    click_link task_content
    click_link "編集"
  end

  def complete_task
    check "終了済"
    click_button "更新する"
  end

  def undo_complete_task
    uncheck "終了済"
    click_button "更新する"
  end

  def expect_complete_task(task_content)
    aggregate_failures do
      expect(page).to have_content "タスクは更新されました。"
      expect(page).to have_css('strike a')
      expect(page).to have_css('strike ~ a.cmd')
      expect(find("strike a").text).to match task_content
    end
  end

  def expect_incomplete_task(task_content)
    aggregate_failures do
      expect(page).to have_content "タスクは更新されました。"
      expect(page).to_not have_css('strike a')
      expect(page).to have_content task_content
    end
  end

  def expect_and_create_task(task_content)
    expect {
      click_link "新規作成"
      fill_in "内容", with: task_content
      click_button "登録する"
      aggregate_failures do
        expect(page).to have_content "タスクが作成されました。"
        expect(page).to have_content task_content
      end
    }
  end

  def expect_and_cant_create_task(task_content, error)
    expect {
      click_link "新規作成"
      fill_in "内容", with: task_content
      click_button "登録する"
      aggregate_failures do
        expect(page).to have_content "入力に問題があります。"
        expect(page).to have_content  error
        expect(page).to have_field '内容', with: task_content
      end
    }
  end

  scenario "ユーザーがタスクを削除する", js: true, vcr: true do
    user = FactoryBot.create(:user, :with_tasks)

    sign_in user

    goto_update_task "Test1 Content"
    complete_task
    expect_complete_task "Test1 Content"

    find('strike ~ a.cmd').click
    expect(page.driver.browser.switch_to.alert.text).to eq "本当に削除しますか？"
    page.driver.browser.switch_to.alert.accept
    expect(page).to have_content "タスクは削除されました。"
    expect(page).to_not have_content "Test1 Content"
  end

  scenario "ユーザーがタスクの状態を切り替える" do
    user = FactoryBot.create(:user, :with_tasks)
    sign_in user

    goto_update_task "Test6 Content"
    complete_task
    expect_complete_task "Test6 Content"

    goto_update_task "Test6 Content"
    undo_complete_task
    expect_incomplete_task "Test6 Content"
  end

  describe "タスクの作成" do
    context "成功する" do

      scenario "ユーザーが新しいタスクを作成すると非同期で管理者とユーザ本人にメールが送られる" do
        user = FactoryBot.create(:user, email: "test@example.com")
        admin = FactoryBot.create(:admin, email: "admin@example.com")
        sign_in user
        visit root_path

        perform_enqueued_jobs do
          expect_and_create_task("Test Task").to change(user.tasks, :count).by(1)
        end

        mail = ActionMailer::Base.deliveries[-2]
        aggregate_failures do
          expect(mail.to).to eq ["admin@example.com"]
          expect(mail.subject).to eq "新しいタスクが作成されました。"
          expect(mail.body).to match "test@example.com"
          expect(mail.body).to match "タスク内容：Test Task"
        end

        mail = ActionMailer::Base.deliveries.last
        aggregate_failures do
          expect(mail.to).to eq ["test@example.com"]
          expect(mail.subject).to eq "新しいタスクが作成されました。"
          expect(mail.body).to match "test@example.com"
          expect(mail.body).to match "タスク内容：Test Task"
        end
      end

      scenario "ユーザーは新しいタスクを作成する" do
        user = FactoryBot.create(:user)
        sign_in user
        visit root_path

        expect_and_create_task("Test Task").to change(user.tasks, :count).by(1)
      end
      scenario "ユーザーは内容が5文字のタスクを作成できる" do
        user = FactoryBot.create(:user)
        sign_in user
        visit root_path

        expect_and_create_task("12345").to change(user.tasks, :count).by(1)
      end
      scenario "ユーザーは他人のタスクと内容が重複していてもタスクを作成できる" do
        other = FactoryBot.create(:user)
        sign_in other
        visit root_path

        expect_and_create_task("Test Task").to change(other.tasks, :count).by(1)
        click_link "ログアウト"

        user = FactoryBot.create(:user)

        sign_in user
        visit root_path

        expect_and_create_task("Test Task").to change(user.tasks, :count).by(1)
      end
    end
    context "失敗する" do
      scenario "ユーザーは内容が空のタスクを作成できない" do
        user = FactoryBot.create(:user)
        sign_in user
        visit root_path

        expect_and_cant_create_task('', "内容を入力してください").
          to_not change(user.tasks, :count)
      end
      scenario "ユーザーは内容が4文字のタスクを作成できない" do
        user = FactoryBot.create(:user)
        # visit root_path
        # fill_in "メールアドレス", with: user.email
        # fill_in "パスワード", with: user.password
        # click_button "ログイン"
        sign_in user
        visit root_path
        
        expect_and_cant_create_task("1234", "内容は5文字以上で入力してください").
          to_not change(user.tasks, :count)
      end
      scenario "ユーザーは自分のタスクと内容が重複したタスクを作成できない" do
        user = FactoryBot.create(:user)
        sign_in user
        visit root_path
        
        expect_and_create_task("Test Task").
          to change(user.tasks, :count).by(1)
        expect_and_cant_create_task("Test Task", "内容はすでに存在します").
          to_not change(user.tasks, :count)
      end
    end
  end
end
