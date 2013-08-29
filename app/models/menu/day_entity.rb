class Menu::DayEntity < ActiveRecord::Base
  belongs_to :day

  def entity=(entity)
  	self.entity_id = entity.id
  end
end
