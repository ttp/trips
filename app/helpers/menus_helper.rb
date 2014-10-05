module MenusHelper
  def render_entities(menu, day_id, parent_id, partition = nil)
    items = menu.entities_children(day_id, parent_id)
    return '' if items.nil?

    html = ''
    items.each do |item|
      html += render_entity(item, menu, partition)
    end
    html.html_safe
  end

  def render_entity(entity, menu, partition = nil)
    model = menu.entity_model(entity)
    html = "<div class='entity entity-#{entity.entity_type}'>
      <span class='entity-name'>#{model.name}</span>"
    if entity.product?
      html += " <span class='weight'>#{entity.weight}#{t('menu.g')}</span>"
      html += render_porters(entity, partition) if partition.present?
    end
    html += "#{render_entities(menu, entity.day_id, entity.id, partition)}</div>"
    html.html_safe
  end

  def render_porters(entity, partition)
    html = ""
    partition.porters_by_entity(entity).each do |item|
      html += content_tag(:span, item[:porter].name + ' ' + item[:weight].to_s + t('menu.g'))
    end
    html.html_safe
  end

  def weight(number)
    (number.to_f / 1000).round(3).to_s + t('menu.kg')
  end

  def round_precision(number)
    if number.to_i == number
      number.to_i
    else
      number
    end
  end

  def menu_can_view?
    @menu.is_public? or
      (user_signed_in? and @menu.user_id == current_user.id) or
      (params[:key] and [@menu.edit_key, @menu.read_key].include?(params[:key]))
  end

  def menu_can_edit?
    (user_signed_in? and (@menu.user_id == current_user.id || admin?)) or
      (params[:key] and @menu.edit_key == params[:key])
  end

  def guest_menu_edit_path(menu)
    edit_menu_menu_url(menu, key: menu.edit_key)
  end

  def guest_owner_menu_path(menu)
    menu_menu_url(menu, key: menu.edit_key)
  end

  def menu_share_path(menu)
    menu_menu_url(menu, key: menu.read_key)
  end

  def product_icon_path(icon)
    icon.blank? ? asset_path('no-image.png') : media_path("products/#{icon}")
  end

  def dish_icon_path(icon)
    icon.blank? ? asset_path('no-image.png') : media_path("dishes/#{icon}")
  end
end