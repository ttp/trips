class Menu::Dish < ActiveRecord::Base
  attr_accessible :name
  translates :name
end
