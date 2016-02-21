class Menu::ProductCategory < ActiveRecord::Base
  include ::Translatable

  has_many :products
  multilang :name

  scope :order_by_name, ->(locale) { order("name->'#{locale}'") }
end
