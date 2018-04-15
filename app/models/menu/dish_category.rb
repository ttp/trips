class Menu::DishCategory < ApplicationRecord
  include ::Translatable

  has_many :dishes

  multilang :name

  scope :order_by_name, ->(locale) { order("name->'#{locale}'") }

  def any_name
    translation(:name)
  end
end
