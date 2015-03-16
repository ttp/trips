class Menu::Day < ActiveRecord::Base
  # attr_accessible :num
  belongs_to :menu
  has_many :menu_day_entities, :class_name => 'Menu::DayEntity'
  has_many :menu_day_product_entities, -> { type_products }, :class_name => 'Menu::DayEntity'
  has_many :menu_day_dish_entities, -> { type_dishes }, :class_name => 'Menu::DayEntity'
end
