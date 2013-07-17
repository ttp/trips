class Menu::Product < ActiveRecord::Base
  attr_accessible :name, :calories, :proteins, :fats, :carbohydrates
  translates :name
  belongs_to :product_category
end
