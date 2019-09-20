module Api
  class TasksController < ApplicationController

    prepend_before_action :authenticate_user_from_token!

    def index
      @tasks = current_user.tasks
      render json: @tasks
    end

    def show
      @task = Task.find(params[:id])
      render json: @task
    end

    def create
      @task = current_user.tasks.new(task_params)

      if @task.save
        render json: { status: :created }
      else
        render json: @task.errors, status: :unprocessable_entity
      end
    end

    private

    def authenticate_user_from_token!
      user_email = params[:user_email].presence
      user = user_email && User.find_by(email: user_email)
      if user && Devise.secure_compare(user.authentication_token, params[:user_token])
        sign_in user, store: true
      else
        render json: { status: "auth failed" }
        false
      end
    end

    def task_params
      params.require(:task).permit(:content, :finished, :due_on)
    end
  end
end
