class Menu::Meal < ActiveRecord::Base
  attr_accessible :name
  translates :name
end