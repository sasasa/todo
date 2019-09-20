require 'rails_helper'

RSpec.describe "Tasks Api", type: :request do
  it "全件のタスク読み出し後に一件のタスクを読み出す" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:task, content: "Sample Task")
    FactoryBot.create(:task, content: "Second Sample Task", user: user)
    get api_tasks_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }
    aggregate_failures do
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json.length).to eq 1  
      task_id = json[0]["id"]
      get api_task_path(task_id), params: {
        user_email: user.email,
        user_token: user.authentication_token
      }
      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)
      expect(json["content"]).to eq "Second Sample Task"
    end
  end

  context "正しい属性値を送信したとき" do
    it "タスクを作成できる" do
      user = FactoryBot.create(:user)
      task_attributes = FactoryBot.attributes_for(:task)
      aggregate_failures do
        expect {
          post api_tasks_path, params: {
            user_email: user.email,
            user_token: user.authentication_token,
            task: task_attributes
          }
        }.to change(user.tasks, :count).by(1)
        expect(response).to have_http_status(:success)
      end
    end
  end
  context "間違った属性値を送信した時" do
    it "タスクを作成できない" do
      user = FactoryBot.create(:user)
      task_attributes = FactoryBot.attributes_for(:task, content: nil)
      aggregate_failures do
        expect {
          post api_tasks_path, params: {
            user_email: user.email,
            user_token: user.authentication_token,
            task: task_attributes
          }
        }.to_not change(user.tasks, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

end
