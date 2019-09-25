require 'rails_helper'

RSpec.describe Task, type: :model do

  # スタブ手法
  it "タスクが作成されたとき管理者あてにメールを送信する" do
    allow(ContactToCreateTaskMailer).to receive_message_chain(:contact_email, :deliver_later)
    admin = FactoryBot.create(:admin)
    user = FactoryBot.create(:user)
    task = FactoryBot.create(:task, user: user)
    expect(ContactToCreateTaskMailer).to have_received(:contact_email).with(task, admin)
  end

  it "タスクが作成されたときユーザーあてにメールを送信する" do
    allow(ContactToCreateTaskMailer).to receive_message_chain(:confirmation_email, :deliver_later)
    user = FactoryBot.create(:user)
    task = FactoryBot.create(:task, user: user)
    expect(ContactToCreateTaskMailer).to have_received(:confirmation_email).with(task)
  end

  it "名前の取得をユーザに移譲する1" do
    user = FactoryBot.create(:user, first_name: "Fake", last_name: "User")
    task = Task.new(user: user)
    expect(task.user_name).to eq "Fake User"
  end

  it "名前の取得をユーザに移譲する2" do
    user = instance_double("User", name: "Fake User")
    task = Task.new
    allow(task).to receive(:user).and_return(user)
    expect(task.user_name).to eq "Fake User"
  end

  let(:user) { FactoryBot.create(:user) }
  it { is_expected.to validate_uniqueness_of(:content).scoped_to(:user_id) }
  describe "締め切り日チェック" do
    it "締め切り日が昨日であれば遅延している" do
      task = FactoryBot.create(:task, :due_yesterday)
      expect(task).to be_late
    end
    it "締め切り日が今日ならスケジュール通りである" do
      task = FactoryBot.create(:task, :due_today)
      expect(task).to_not be_late
    end
    it "締め切り日が明日ならスケジュール通りである" do
      task = FactoryBot.create(:task, :due_tomorrow)
      expect(task).to_not be_late
    end
  end

  describe "内容の文字数チェック" do
    context "最小値文字列長チェック" do
      it "内容が4文字以下であれば無効な状態である" do
        # task = Task.new(
        #   content: "a" * 4,
        #   user: @user
        # )
        task = FactoryBot.build(:task, content: "a" * 4)
        task.valid?
        expect(task.errors[:content]).to include("は5文字以上で入力してください")
      end
      it "内容が5文字以上であれば有効な状態である" do
        task = FactoryBot.build(:task, content: "a" * 5)
        expect(task).to be_valid
      end      
    end
    context "最大値文字列長チェック" do
      it "内容が100文字以内であれば有効な状態である" do
        task = FactoryBot.build(:task, content: "a" * 100)
        expect(task).to be_valid
      end
      it "内容が101文字以上であれば無効な状態である" do
        task = FactoryBot.build(:task, content: "a" * 101)
        task.valid?
        expect(task.errors[:content]).to include("は100文字以内で入力してください")
      end
    end

    it "内容がなければ無効な状態である" do
      task = FactoryBot.build(:task, content: nil)
      task.valid?
      expect(task.errors[:content]).to include("を入力してください")
    end
  end
  describe "内容の重複チェック" do
    it "2人のユーザーは同じタスクの内容を登録できる" do
      user.tasks.create(
        content: "Test task"
      )
      other_user = FactoryBot.create(:user)
      new_task = other_user.tasks.build(
        content: "Test task"
      )
      expect(new_task).to be_valid
    end
    it "ユーザー単位では重複したタスク内容を登録できない" do
      # @user.tasks.create(
      #   content: "Test task"
      # )
      u = FactoryBot.create(:task, content: "Test task").user
      new_task = FactoryBot.build(:task, content: "Test task", user: u)
       
      # new_task = @user.tasks.build(
      #   content: "Test task"
      # )
      new_task.valid?
      expect(new_task.errors[:content]).to include("はすでに存在します")
    end
  end
end
