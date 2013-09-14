class Menu::Dish < ActiveRecord::Base
  attr_accessible :name
  has_many :dish_products
  belongs_to :dish_category
  translates :name
  class Translation
    attr_accessible :locale
  end

  def self.by_lang(lang)
    connection.select_all(
      "SELECT d.id, d.dish_category_id, dt.name FROM menu_dishes d
      JOIN menu_dish_translations dt ON dt.menu_dish_id = d.id
      WHERE dt.locale = #{quote_value(lang)}")
  end
end
