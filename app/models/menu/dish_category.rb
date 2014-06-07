class Menu::DishCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :dishes
  translates :name
  class Translation
    attr_accessible :locale
  end

  def self.by_lang(lang)
    connection.select_all(
      "SELECT dc.id, dct.name FROM menu_dish_categories dc
      JOIN menu_dish_category_translations dct ON dct.menu_dish_category_id = dc.id
      WHERE dct.locale = #{quote_value(lang)}
      ORDER BY dct.name")
  end
end
