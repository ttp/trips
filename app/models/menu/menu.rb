require 'securerandom'

class Menu::Menu < ActiveRecord::Base
  belongs_to :user
  has_many :menu_days, class_name: 'Menu::Day'
  has_many :menu_day_product_entities, class_name: 'Menu::DayEntity', through: :menu_days
  has_many :menu_day_dish_entities, class_name: 'Menu::DayEntity', through: :menu_days
  has_many :menu_products, class_name: 'Menu::Product', through: :menu_day_product_entities
  has_many :menu_dishes, class_name: 'Menu::Dish', through: :menu_day_dish_entities
  has_many :partitions, class_name: 'Menu::Partition'

  before_save :make_entities_public, if: :is_public?

  after_initialize do |menu|
    if menu.read_key.blank?
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
    return @entities if @entities
    if new_record?
      @entities = []
    else
      @entities = Menu::DayEntity.order('sort_order').joins(day: :menu).
                                  where('menu_menus.id = ?', id).readonly(false)
    end
  end

  def entities=(entities)
    @entities = entities
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
    @products = Menu::Product.where('menu_products.id in(?)', ids).preload(:translations).to_a
    @products.sort! { |a, b| a.name <=> b.name }
    @products = @products.index_by(&:id)
  end

  def dishes
    return @dishes if @dishes

    ids = entities_by_type(Menu::DayEntity::DISH).map(&:entity_id).uniq
    @dishes = Menu::Dish.where('menu_dishes.id in(?)', ids).preload(:translations).index_by(&:id)
  end

  def meals
    @meals || (@meals = Menu::Meal.preload(:translations).index_by(&:id))
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
      entities_grouped[day_id][parent_id]
    else
      []
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

  def make_entities_public
    private_products.update_all is_public: true
    private_dishes.update_all is_public: true
  end

  private

  def private_products
    menu_products.is_private
  end

  def private_dishes
    menu_dishes.is_private
  end
end
