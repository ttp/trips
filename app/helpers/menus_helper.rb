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
    html = "<div class='entity entity-#{entity.entity_type} clearfix'>
      <span class='entity-name'>#{entity.custom_name || model.translation(:name)}</span>"
    if entity.notes.present?
      html += "<div class='notes-text text-warning'>#{entity.notes}</div>"
    end
    if entity.product?
      html += " <span class='weight'>#{entity.weight}#{t('menu.g')}/#{entity.weight * menu.users_count}#{t('menu.g')}</span>"
      html += render_porters(entity, partition) if partition.present?
    end
    html += "#{render_entities(menu, entity.day_id, entity.id, partition)}</div>"
    html.html_safe
  end

  def render_porters(entity, partition)
    html = "<span class='entity-porters pull-right'>"
    partition.porters_by_entity(entity).each do |item|
      html += content_tag(:span, item[:porter].name + ' ' + item[:weight].to_s + t('menu.g'), class: 'porter')
    end
    html += '</span>'
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

  def cell_class(cell_num)
    class_name = ''
    class_name += 'cell2' if cell_num.even?
    class_name += 'cell3' if (cell_num % 3 == 0)
    class_name
  end

  def menu_can_view?
    Pundit.policy(current_user, @menu).show? params[:key]
  end

  def menu_can_edit?
    Pundit.policy(current_user, @menu).edit? params[:key]
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

  def menu_cache_key(menu)
    "#{menu.id}-#{menu.updated_at}-#{menu.users_count}"
  end

  def menu_partition_cache_key(menu, partition = nil)
    return menu_cache_key(menu) unless partition
    menu_cache_key(menu) + "-#{partition.id}-#{partition.updated_at}"
  end

  def sorted_products(products)
    products.sort_by {|key, product_total| product_total[:product].translation(:name) }.to_h
  end
end
