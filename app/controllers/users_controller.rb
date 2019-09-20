class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  before_action :authenticate_admin!, only: [:index]

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if params[:user] && image = params[:user][:image]
      @user.image.attach(image)
    end
    redirect_to(edit_user_path(current_user.id), notice: "画像をアップロードしました。")
  end

  def index
    @users = User.all
    @user =
      if params[:user_id]
        User.find(params[:user_id])
      else
        User.first
      end
  end
end
