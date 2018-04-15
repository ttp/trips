class Menu::DayEntity < ApplicationRecord
  MEAL = 1
  DISH = 2
  PRODUCT = 3

  belongs_to :day
  has_many :partition_porter_products, class_name: 'Menu::PartitionPorterProduct', dependent: :delete_all
  belongs_to :menu_product, :class_name => 'Menu::Product', foreign_key: :entity_id, optional: true
  belongs_to :menu_dish, :class_name => 'Menu::Dish', foreign_key: :entity_id, optional: true

  scope :type_products, -> { where entity_type: PRODUCT }
  scope :type_dishes, -> { where entity_type: DISH }

  def entity=(entity)
    self.entity_id = entity.id
  end

  def product?
    entity_type == PRODUCT
  end
end
