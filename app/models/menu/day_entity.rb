class Menu::DayEntity < ActiveRecord::Base
  MEAL = 1
  DISH = 2
  PRODUCT = 3

  belongs_to :day
  has_many :partition_porter_products, :class_name => 'Menu::PartitionPorterProduct', dependent: :delete_all

  def entity=(entity)
  	self.entity_id = entity.id
  end

  def product?
    entity_type == PRODUCT
  end
end
