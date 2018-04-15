class Menu::ProductCategory < ApplicationRecord
  include ::Translatable

  has_many :products
  multilang :name

  scope :order_by_name, ->(locale) { order("name->'#{locale}'") }

  def any_name
    translation(:name)
  end
end
