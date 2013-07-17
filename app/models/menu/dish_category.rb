class Menu::DishCategory < ActiveRecord::Base
  attr_accessible :name
  translates :name
end
