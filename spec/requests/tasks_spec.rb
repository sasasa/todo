require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  context "認証済みユーザーとして" do

    let(:user) { FactoryBot.create(:user) }

    context "有効な属性値の時" do
      it "タスクを追加できる" do
        task_params = FactoryBot.attributes_for(:task)
        sign_in user
        expect {
          post tasks_path, params: { task: task_params }
        }.to change(user.tasks, :count).by(1)
      end
    end
    context "無効な属性値の時" do
      it "タスクを追加できない" do
        task_params = FactoryBot.attributes_for(:task, :invalid)
        sign_in user
        expect {
          post tasks_path, params: { task: task_params }
        }.to_not change(user.tasks, :count)
      end
    end
  end
end
