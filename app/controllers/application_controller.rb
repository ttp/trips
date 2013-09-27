class ApplicationController < ActionController::Base
  after_filter :store_location
  protect_from_forgery

protected
  def store_location
    if request.get? and controller_name != "user_sessions" and controller_name != "sessions"
      session[:return_to] = request.fullpath
    end
    if !user_signed_in? and request.get? and
       request.fullpath != "/users/sign_in" and
       request.fullpath != "/users/sign_up" and
       request.fullpath != "/users/password" and
       !request.xhr?
      session[:previous_url] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def back(url)
    params[:back_url] || url
  end

  def order
    if !params[:sort].nil? && @sortable_fields.has_key?(params[:sort])
      @sortable_fields[params[:sort]] + ' ' + (params[:dir] == 'desc' ? 'desc' : 'asc')
    else
      @default_sort
    end
  end
end
