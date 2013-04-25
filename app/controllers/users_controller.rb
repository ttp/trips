class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:ulogin]
  protect_from_forgery :except => [:ulogin]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.user_profile
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

  def profile
    @profile = current_user.user_profile
    @profile = UserProfile.new if @profile.nil?
  end

  # POST /users/profile
  def update_profile
    @profile = current_user.user_profile
    @profile = current_user.create_user_profile if @profile.nil?

    if @profile.update_attributes(params[:user_profile])
      redirect_to user_path(current_user), notice: I18n.t('user_profile.was_updated')
    else
      render action: "profile"
    end
  end
end
