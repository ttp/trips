module ApplicationHelper
  def display_base_errors resource
    return '' if (resource.errors.empty?) or (resource.errors[:base].empty?)
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
      #{link_to label, params.merge(sort_params)}
    </th>
    HTML
    html.html_safe
  end

  def title(page_title)
    content_for(:title, page_title.to_s + ' - ')
    return page_title
  end

  def return_here_path(path)
    path + '?return=' + u(request.fullpath)
  end

  def back_url(path = nil)
    params[:back_url] || request.referer || path
  end
end
