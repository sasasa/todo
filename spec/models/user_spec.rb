require 'rails_helper'

RSpec.describe User, type: :model do

  it "ジオコーディングを実行する", vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).from(nil).to("Brooklyn, New York, US")
  end
  
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to validate_presence_of :email }
  # it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  # it { is_expected.to validate_uniqueness_of(:email) }

  it "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "ファクトリでユーザを保存するとタスクも5つ作られている" do
    user = FactoryBot.create(:user, :with_tasks)
    expect(user.tasks.count).to eq 5
  end

  it "メールアドレスとパスワードがあれば有効な状態である" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end
  it "メールアドレスがなければ無効な状態である" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("が入力されていません。")
  end
  it "パスワードがなければ無効な状態である" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("が入力されていません。")
  end
  it "重複したメールアドレスなら無効な状態である" do
    FactoryBot.create(:user, email: "test@example.com")
    user = FactoryBot.build(:user, email: "test@example.com")

    user.valid?
    expect(user.errors[:email]).to include("は既に使用されています。")
  end
end
