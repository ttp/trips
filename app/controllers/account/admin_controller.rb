class Account::AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  def index
    session[:admin] ||= current_user.id
  end

  def switch_user
  end

  protected

  def authenticate_admin!
    if admin?
      return true
    end

    flash[:notice] = 'You must admin to access this page'
    redirect_to root_url and return false
  end
end
