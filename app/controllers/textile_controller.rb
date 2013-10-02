class TextileController < ActionController::Base
  def preview
    render text: RedCloth.new(params[:data], [:filter_html]).to_html
  end
end
