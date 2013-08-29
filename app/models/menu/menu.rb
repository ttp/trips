class Menu::Menu < ActiveRecord::Base
  attr_accessible :name, :users_qty, :is_public
  belongs_to :user
  has_many :menu_days, :class_name => 'Menu::Day'

  def entities
    @entitties || @entities = Menu::DayEntity.joins(day: :menu).where('menu_menus.id = ?', self.id)
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
    @products = Menu::Product.with_translations(I18n.locale).where('menu_products.id in(?)', ids).index_by(&:id)
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
    entities.select {|entity| entity.entity_type == type}
  end

  def entities_grouped
    return @grouped if @grouped

    @grouped = entities.group_by {|entity| entity.day_id}
    @grouped.each do |day_id, group|
      @grouped[day_id] = group.group_by {|entity| entity.parent_id || 0}
    end
  end

  def entities_children(day_id, parent_id)
    entities_grouped[day_id][parent_id]
  end
end