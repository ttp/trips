class Menu::ProductCategory < ActiveRecord::Base
  attr_accessible :name
  translates :name
  has_many :products
end
