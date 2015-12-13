module Menu
  class TableRenderer
    attr_reader :menu, :partition

    def initialize(menu, partition, template)
      @menu = menu
      @partition = partition
      @template = template
    end

    def render
      content_tag :table, class: 'table table-hover menu-table' do
        # concat content_tag :tr, content_tag(:th, 'Day num')
        concat header_row
        concat render_days
      end
    end

    def header_row
      content_tag :tr do
        concat content_tag :th, I18n.t('menu.products.name')
        concat content_tag :th, I18n.t('menu.weight') + "(#{I18n.t('menu.g')})"
        concat content_tag :th, I18n.t('menu.total_entity_weight') + "(#{I18n.t('menu.g')})"
        concat content_tag :th, I18n.t('menu.porters') if partition.present?
      end
    end

    def render_days
      html = ''
      @menu.days.each_with_index do |day, i|
        html += day_title_row(i + 1)
        html += render_entities(day.id, 0)
      end
      html.html_safe
    end

    def day_title_row(num)
      content_tag :tr, class: 'active' do
        concat content_tag :th, I18n.t('menu.day') + " #{num}"
        concat ('<th></th>' * 2).html_safe
        concat '<th></th>'.html_safe if partition.present?
      end
    end

    def render_entities(day_id, parent_id, lvl = 1)
      items = menu.entities_children(day_id, parent_id)
      return '' if items.nil?

      html = ''
      items.each do |item|
        html += render_entity(item, lvl)
      end
      html.html_safe
    end

    def render_entity(entity, lvl)
      html = "<tr class='entity entity-#{entity.entity_type} entity-lvl-#{lvl}'>" + name_cell(entity)
      if entity.product?
        html += "<td class='weight'>#{entity.weight}</td><td>#{entity.weight * menu.users_count}</td>"
        html += porters_cell(entity) if partition.present?
      else
        html += ('<td></td>' * 2).html_safe
        html += '<th></th>'.html_safe if partition.present?
      end
      html += '</tr>'
      html += render_entities(entity.day_id, entity.id, lvl + 1)
      html.html_safe
    end

    def name_cell(entity)
      content_tag :td, name_tag(entity), class: 'entity-name-cell'
    end

    def name_tag(entity)
      tag = entity.product? ? :span : :b
      content_tag tag, entity_name(entity), class: 'entity-name'
    end

    def entity_name(entity)
      entity.custom_name || menu.entity_model(entity).name
    end

    def porters_cell(entity)
      html = "<td class='entity-porters'>"
      partition.porters_by_entity(entity).each do |item|
        html += content_tag(:span, "#{item[:porter].name}&nbsp;#{item[:weight]}#{I18n.t('menu.g')} ".html_safe, class: 'porter')
      end
      html += '</td>'
      html.html_safe
    end

    def method_missing(*args, &block)
      @template.send(*args, &block)
    end
  end

end
