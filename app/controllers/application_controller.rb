class ApplicationController < ActionController::Base
  include Pundit
  after_filter :store_location
  before_filter :configure_permitted_parameters, :if => :devise_controller?
  protect_from_forgery
  helper_method :admin?
  helper_method :permissions_for

protected
  def store_location
    if request.get? and controller_name != "user_sessions" and controller_name != "sessions"
      session[:return_to] = request.fullpath
    end
    if params[:return] && !user_signed_in? and request.get? and !request.xhr?
      session[:previous_url] = params[:return]
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def back(url)
    if params[:back_url] && !params[:back_url].empty?
      params[:back_url]
    else
      url
    end
  end

  def order
    if !params[:sort].nil? && @sortable_fields.has_key?(params[:sort])
      @sortable_fields[params[:sort]] + ' ' + (params[:dir] == 'desc' ? 'desc' : 'asc')
    else
      @default_sort
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  def admin?
    current_user && current_user.admin? || session[:admin]
  end

  def permissions
    @permissions ||= Permissions::Acl.new(current_user)
  end

  def permissions_for(resource)
    permissions.for_resource(resource)
  end
end
