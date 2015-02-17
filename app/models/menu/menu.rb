require 'securerandom'

class Menu::Menu < ActiveRecord::Base
  # attr_accessible :name, :users_count, :is_public
  belongs_to :user
  has_many :menu_days, class_name: 'Menu::Day'
  has_many :partitions, class_name: 'Menu::Partition'

  after_initialize do |menu|
    if menu.read_key.empty?
      menu.read_key = SecureRandom.urlsafe_base64(16)
      menu.edit_key = SecureRandom.urlsafe_base64(16)
    end
  end

  def owner?(user)
    user && user_id.present? && user_id == user.id
  end

  def days
    @days ||= menu_days.order('num')
  end

  def entities
    return [] if new_record?
    @entities ||= Menu::DayEntity.order('sort_order').joins(day: :menu).where('menu_menus.id = ?', id).readonly(false)
  end

  def entity_model(day_entity)
    case day_entity.entity_type
      when Menu::DayEntity::PRODUCT then products[day_entity.entity_id]
      when Menu::DayEntity::DISH then dishes[day_entity.entity_id]
      when Menu::DayEntity::MEAL then meals[day_entity.entity_id]
    end
  end

  def products
    return @products if @products

    ids = entities_by_type(Menu::DayEntity::PRODUCT).map(&:entity_id).uniq
    @products = Menu::Product.with_translations(I18n.locale)
                .where('menu_products.id in(?)', ids).to_a
    @products.sort! { |a, b| a.name <=> b.name }
    @products = @products.index_by(&:id)
    @products
  end

  def dishes
    return @dishes if @dishes

    ids = entities_by_type(Menu::DayEntity::DISH).map(&:entity_id).uniq
    @dishes = Menu::Dish.with_translations(I18n.locale).where('menu_dishes.id in(?)', ids).index_by(&:id)
  end

  def meals
    @meals || (@meals = Menu::Meal.with_translations(I18n.locale).index_by(&:id))
  end

  def entities_by_type(type)
    entities.select { |entity| entity.entity_type == type }
  end

  def entities_grouped
    return @grouped if @grouped

    @grouped = entities.group_by(&:day_id)
    @grouped.each do |day_id, group|
      @grouped[day_id] = group.group_by { |entity| entity.parent_id || 0 }
    end
  end

  def entities_children(day_id, parent_id)
    if entities_grouped.key?(day_id)
      return entities_grouped[day_id][parent_id]
    else
      return []
    end
  end

  def total
    return @total if @total
    @total = {
      weight: 0,
      calories: 0,
      proteins: 0,
      fats: 0,
      carbohydrates: 0
    }

    entities_by_type(Menu::DayEntity::PRODUCT).each do |entity|
      @total[:weight] += entity.weight
      product = entity_model(entity)
      @total[:calories] += product.calories.to_f * entity.weight / 100
      @total[:proteins] += product.proteins.to_f * entity.weight / 100
      @total[:fats] += product.fats.to_f * entity.weight / 100
      @total[:carbohydrates] += product.carbohydrates.to_f * entity.weight / 100
    end
    @total
  end

  def total_products
    return @total_products if @total_products
    @total_products = entities_by_type(Menu::DayEntity::PRODUCT).group_by(&:entity_id)
    @total_products.each do |key, items|
      @total_products[key] = items.inject(0) { |mem, item| mem + item.weight }
    end
    @total_products
  end
end
