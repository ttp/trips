class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:ulogin]
  before_filter :protect_from_forgery, :except => [:ulogin]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def ulogin
    auth_service = AuthService.new
    user = auth_service.authenticate(params[:token])
    if user
      sign_in user, :bypass => true
      redirect_to root_path
    else
      flash[:error] = "Unable to login"
      redirect_to new_user_session_path
    end
  end

end
