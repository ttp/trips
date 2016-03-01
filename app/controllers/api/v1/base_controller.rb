class Api::V1::BaseController < ActionController::Base
  include Pundit
  before_action :set_locale
  protect_from_forgery

  protected

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
