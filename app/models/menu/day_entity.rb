class Menu::DayEntity < ActiveRecord::Base
  MEAL = 1
  DISH = 2
  PRODUCT = 3

  belongs_to :day

  def entity=(entity)
  	self.entity_id = entity.id
  end

  def product?
    entity_type == PRODUCT
  end
end
