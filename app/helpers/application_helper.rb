# encoding: UTF-8

module ApplicationHelper
  def display_base_errors(resource)
    return '' if (resource.errors.empty?) || (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  def sortable_header(field, label)
    classes = 'sortable'
    sort_params = {
      sort: field,
      dir: 'asc'
    }
    if params[:sort] === field
      classes += ' sorted'
      classes += params[:dir] == 'asc' ? ' headerSortUp' : ' headerSortDown'
      sort_params[:dir] = 'desc' if params[:dir] == 'asc'
    end

    html = <<-HTML
    <th class="#{classes}">
      #{link_to label, params.permit('*').merge(sort_params)}
    </th>
    HTML
    html.html_safe
  end

  def title(page_title)
    content_for(:title, page_title.to_s + ' - ')
    page_title
  end

  def return_here_path(path)
    path + '?return=' + u(request.fullpath)
  end

  def back_url(path = nil)
    params[:back_url] || request.referer || path
  end

  def safe_textile(message)
    message = message.gsub(/javascript/i, 'jаvаsсrірt')
    RedCloth.new(message, [:filter_html, :filter_styles, :filter_classes, :filter_ids]).to_html
  end

  def return_path
    request.original_fullpath.include?('return=') ? root_path : request.original_fullpath
  end

  def alert_class(flash_type)
    case flash_type
    when 'success'
      'alert-success' # Green
    when 'error'
      'alert-danger' # Red
    when 'alert'
      'alert-warning' # Yellow
    when 'notice'
      'alert-info' # Blue
    else
      flash_type.to_s
    end
  end

  def link_to_current_page_in_locale(code, locale)
    param_code = code == I18n.default_locale ? nil : locale[:code]
    if request.query_string.empty?
      link_to locale[:name], locale: param_code
    else
      link_to locale[:name], params.permit('*').merge(locale: param_code)
    end
  end
end
