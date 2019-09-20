require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe "#destroy" do
    context "認可されたユーザーとして" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: @user)
      # end
      let(:user) { FactoryBot.create(:user) }
      let!(:task) { FactoryBot.create(:task, user: user) }

      it "タスクを削除できる" do
        sign_in user
        expect {
          delete :destroy, params: { id: task.id }
        }.to change(user.tasks, :count).by(-1)
      end
    end
    context "認可されていないユーザーとして" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   other_user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: other_user)
      # end
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let!(:task) { FactoryBot.create(:task, user: other_user) }
      it "タスクを削除できない" do
        sign_in user
        expect {
          delete :destroy, params: { id: task.id }
        }.to_not change(Task, :count)
      end
      it "ダッシュボードにリダイレクトする" do
        sign_in user
        delete :destroy, params: { id: task.id }
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストユーザーとして" do
      # before do
      #   @task = FactoryBot.create(:task)
      # end
      let!(:task) { FactoryBot.create(:task) }
      it "302レスポンスを返す" do
        delete :destroy, params: { id: task.id }
        expect(response).to have_http_status 302
      end
      it "サインイン画面にリダイレクトする" do
        delete :destroy, params: { id: task.id }
        expect(response).to redirect_to "/users/sign_in"
      end
      it "タスクを削除できない" do
        expect {
          delete :destroy, params: { id: task.id }
        }.to_not change(Task, :count)
      end
    end
  end
  
  describe "#update" do
    context "認可されたユーザーとして自分のタスクを更新する" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: @user)
      # end
      let(:user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user: user) }

      it "タスクを更新できる" do
        task_params = FactoryBot.attributes_for(:task, content: "New Task Name")
        sign_in user
        patch :update, params: { id: task.id, task: task_params }
        expect(task.reload.content).to eq "New Task Name"
      end
    end
    context "認可されていないユーザーとして他人のタスクを更新する" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   other_user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: other_user, content: "Same Old Name")
      # end
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user: other_user, content: "Same Old Name") }

      it "タスクを更新できない" do
        task_params = FactoryBot.attributes_for(:task, content: "New Name")
        sign_in user
        patch :update, params: { id: task.id, task: task_params }
        expect(task.reload.content).to eq "Same Old Name"
      end
      it "ダッシュボードにリダイレクトする" do
        task_params = FactoryBot.attributes_for(:task)
        sign_in user
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストユーザーとしてタスクを更新する" do
      # before do
      #   @task = FactoryBot.create(:task)
      # end
      let(:task) { FactoryBot.create(:task) }

      it "302レスポンスを返すこと" do
        task_params = FactoryBot.attributes_for(:task)
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to have_http_status 302
      end
      it "サインイン画面にリダイレクトする" do
        task_params = FactoryBot.attributes_for(:task)
        patch :update, params: { id: task.id, task: task_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
  describe "#show" do
    context "JSON形式について" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: @user)
      # end
      let(:user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user: user) }
      
      it "JSON形式でレスポンスを返す" do
        sign_in user
        get :show, format: :json, params: { id: task.id }
        # expect(response.content_type).to eq "application/json"
        expect(response).to have_content_type :json
      end
    end

    context "認可されたユーザーとして自分のタスクにアクセスする" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: @user)
      # end
      let(:user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user: user) }
      
      it "正常にレスポンスを返す" do
        sign_in user
        get :show, params: { id: task.id }
        expect(response).to be_successful
      end
    end
    context "認可されていないユーザーとしてとして他人のタスクにアクセスする" do
      # before do
      #   @user = FactoryBot.create(:user)
      #   other_user = FactoryBot.create(:user)
      #   @task = FactoryBot.create(:task, user: other_user)
      # end
      let(:user) { FactoryBot.create(:user) }
      let(:other_user) { FactoryBot.create(:user) }
      let(:task) { FactoryBot.create(:task, user: other_user) }

      it "アクセスできずダッシュボードにリダイレクトする" do
        sign_in user
        get :show, params: { id: task.id }
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#create" do

    context "JSON形式について" do
      # before do
      #   @user = FactoryBot.create(:user)
      # end
      let(:user) { FactoryBot.create(:user) }

      context "有効な属性値の場合" do
        it "JSON形式でレスポンスを返す" do
          new_task = FactoryBot.attributes_for(:task)
          sign_in user
          post :create, format: :json, params: { task: new_task }
          # expect(response.content_type).to eq "application/json"
          expect(response).to have_content_type :json
        end
        it "新しいタスクをプロジェクトに追加する" do
          new_task = FactoryBot.attributes_for(:task)
          sign_in user
          expect {
            post :create, format: :json, params: { task: new_task }
          }.to change(user.tasks, :count).by(1)
        end
        it "認証を要求する" do
          new_task = FactoryBot.attributes_for(:task)
          expect {
            post :create, format: :json, params: { task: new_task }
          }.to_not change(user.tasks, :count)
          expect(response).to_not be_successful
        end
      end
      context "無効な属性値の場合" do
        it "JSON形式でレスポンスを返す" do
          new_task = FactoryBot.attributes_for(:task, :invalid)
          sign_in user
          post :create, format: :json, params: { task: new_task }
          # expect(response.content_type).to eq "application/json"
          expect(response).to have_content_type :json
        end
        it "タスクをプロジェクトに追加できない" do
          new_task = FactoryBot.attributes_for(:task, :invalid)
          sign_in user
          expect {
            post :create, format: :json, params: { task: new_task }
          }.to_not change(user.tasks, :count)
        end
      end
    end

    context "認証済みユーザーとして" do
      # before do
      #   @user = FactoryBot.create(:user)
      # end
      let(:user) { FactoryBot.create(:user) }

      context "有効な属性値の場合" do
        it "タスクを追加できること" do
          task_params = FactoryBot.attributes_for(:task)
          sign_in user
          expect {
            post :create, params: { task: task_params }
          }.to change(user.tasks, :count).by(1)
        end
      end
      context "無効な属性値の場合" do
        it "タスクを追加できない" do
          task_params = FactoryBot.attributes_for(:task, :invalid)
          sign_in user
          expect {
            post :create, params: { task: task_params }
          }.to_not change(user.tasks, :count)
        end
      end

    end
    context "ゲストユーザーとして" do
      it "タスクを追加できずに302レスポンスを返すこと" do
        task_params = FactoryBot.attributes_for(:task)
        post :create, params: { task: task_params }
        expect(response).to have_http_status 302
      end
      it "サインイン画面にリダイレクトする" do
        task_params = FactoryBot.attributes_for(:task)
        post :create, params: { task: task_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#index" do
    context "JSON形式について" do
      # before do
      #   @user = FactoryBot.create(:user)
      # end
      let(:user) { FactoryBot.create(:user) }

      it "JSON形式でレスポンスを返す" do
        sign_in user
        get :index, format: :json
        # expect(response.content_type).to eq "application/json"
        expect(response).to have_content_type :json
      end
    end
    
    context "認証済みユーザーとして" do
      # before do
      #   @user = FactoryBot.create(:user)
      # end
      let(:user) { FactoryBot.create(:user) }

      it "正常にレスポンスを返す" do
        sign_in user
        get :index
        expect(response).to be_successful
      end
      it "200レスポンスを返す" do
        sign_in user
        get :index
        expect(response).to have_http_status 200
      end
    end

    context "ゲストユーザーとして" do
      it "302レスポンスを返す" do
        get :index
        expect(response).to have_http_status 302
      end
      it "サインインページにリダイレクト" do
        get :index
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
