class Menu::Meal < ActiveRecord::Base
  include ::Translatable

  multilang :name

  scope :order_by_name, ->(locale) { order("name->'#{locale}'") }
end
