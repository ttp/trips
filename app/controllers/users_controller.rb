class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:ulogin, :show]
  protect_from_forgery except: [:ulogin]

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
      sign_in_and_redirect user, bypass: true
    else
      flash[:error] = 'Unable to login'
      redirect_to new_user_session_path
    end
  end

  def edit_profile
    @profile = current_user.user_profile || current_user.build_user_profile
  end

  def update_profile
    @profile = current_user.user_profile || current_user.build_user_profile

    if @profile.update_attributes(profile_params)
      redirect_to user_path(current_user), notice: I18n.t('user_profile.was_updated')
    else
      render action: 'edit_profile'
    end
  end

  private

  def profile_params
    params.require(:user_profile).permit(:about, :experience, :equipment, :contacts, :private_contacts, :private_info)
  end
end
