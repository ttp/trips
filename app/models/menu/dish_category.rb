class Menu::DishCategory < ActiveRecord::Base
  include ::Translatable

  has_many :dishes

  multilang :name

  scope :order_by_name, ->(locale) { order("name->'#{locale}'") }

  def self.by_lang(lang)
    connection.select_all(
      "SELECT dc.id, dct.name FROM menu_dish_categories dc
      JOIN menu_dish_category_translations dct ON dct.menu_dish_category_id = dc.id
      WHERE dct.locale = #{connection.quote(lang)}
      ORDER BY dct.name")
  end
end
