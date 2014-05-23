class TextileController < ActionController::Base
  include ApplicationHelper

  def preview
    render text: safe_textile(params[:data])
  end
end
