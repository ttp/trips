class TextileController < ActionController::Base
  include ApplicationHelper

  def preview
    render plain: safe_textile(params[:data])
  end
end
