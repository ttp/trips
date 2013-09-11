module MenusHelper
  def render_entities(menu, day_id, parent_id)
    items = menu.entities_children(day_id, parent_id)
    return '' if items.nil?

    html = ''
    items.each do |item|
      html += render_entity(item, menu)
    end
    html.html_safe
  end

  def render_entity(entity, menu)
    model = menu.entity_model(entity)
    html = "<div class='entity entity-#{entity.entity_type}'>
      <span class='entity-name'>#{model.name}</span>"
    if entity.product?
      html += " <span class='weight'>#{entity.weight}#{t('menu.g')}</span>"
    end
    html += "#{render_entities(menu, entity.day_id, entity.id)}</div>"
    html.html_safe
  end

  def weight(number)
    (number.to_f / 1000).to_s + t('menu.kg')
  end

  def round_precision(number)
    if number.to_i == number
      return number.to_i
    else
      return number
    end
  end
end