class Menu::DishProduct < ActiveRecord::Base
  belongs_to :dish
  belongs_to :product
end