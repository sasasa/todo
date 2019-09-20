require "rails_helper"

RSpec.describe ContactToCreateTaskMailer, type: :mailer do
  describe "#confirmation_email" do
    context "名前が設定されているとき" do
      let(:user) { FactoryBot.create(:user, first_name: "後藤", last_name: "まさし") }
      let(:task) { FactoryBot.create(:task, user: user) }
      let(:mail) { ContactToCreateTaskMailer.confirmation_email(task) }
  
      it "報告メールをユーザ自身のアドレスに送信する" do
        expect(mail.to).to eq [user.email]
      end
      it "サポート用のアドレスから送信する" do
        # 実際は違うけどテストが通ってしまう
        expect(mail.from).to eq ["support@example.com"]
      end
      it "正しい件名で送信する" do
        expect(mail.subject).to eq "新しいタスクが作成されました。"
      end
      it "ユーザには名前であいさつする" do
        expect(mail.body).to match(/こんにちは#{user.name}様/)
      end
      it "ユーザにはメールアドレスであいさつしない" do
        expect(mail.body).to_not match(/こんにちは#{user.email}様/)
      end
      it "登録したタスクの内容が表示されている" do
        expect(mail.body).to match(/#{task.content}/)
      end
      it "登録したタスクを登録した人の名前が表示されている" do
        expect(mail.body).to match(/#{user.name}/)
      end
    end
    context "名前が設定されていないとき" do
      let(:user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user: user) }
      let(:mail) { ContactToCreateTaskMailer.confirmation_email(task) }

      it "報告メールをユーザ自身のアドレスに送信する" do
        expect(mail.to).to eq [user.email]
      end
      it "サポート用のアドレスから送信する" do
        # 実際は違うけどテストが通ってしまう
        expect(mail.from).to eq ["support@example.com"]
      end
      it "正しい件名で送信する" do
        expect(mail.subject).to eq "新しいタスクが作成されました。"
      end
      it "ユーザには名前であいさつしない" do
        expect(mail.body).to_not match(/こんにちは#{user.name}様/)
      end
      it "ユーザにはメールアドレスであいさつする" do
        expect(mail.body).to match(/こんにちは#{user.email}様/)
      end
      it "登録したタスクの内容が表示されている" do
        expect(mail.body).to match(/#{task.content}/)
      end
      it "登録したタスクを登録した人の名前が表示されている" do
        expect(mail.body).to match(/#{user.name}/)
      end
    end
  end
  
  describe "#contact_email" do
    let(:user) { FactoryBot.create(:user) }
    let(:task) { FactoryBot.create(:task, user: user) }
    let(:admin) { FactoryBot.create(:admin) }
    let(:mail) { ContactToCreateTaskMailer.contact_email(task, admin) }

    it "報告メールを管理者のアドレスに送信する" do
      expect(mail.to).to eq [admin.email]
    end
    it "サポート用のアドレスから送信する" do
      # 実際は違うけどテストが通ってしまう
      expect(mail.from).to eq ["support@example.com"]
    end
    it "正しい件名で送信する" do
      expect(mail.subject).to eq "新しいタスクが作成されました。"
    end
    it "管理者にはメールアドレスであいさつする" do
      expect(mail.body).to match(/#{admin.email}様/)
    end
    it "登録したタスクの内容が表示されている" do
      expect(mail.body).to match(/#{task.content}/)
    end
    it "登録したタスクを登録した人の名前が表示されている" do
      expect(mail.body).to match(/#{user.name}/)
    end
  end
end
