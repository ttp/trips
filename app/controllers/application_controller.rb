class ApplicationController < ActionController::Base
  protect_from_forgery

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
