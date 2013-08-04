class Menu::Product < ActiveRecord::Base
  attr_accessible :name, :calories, :proteins, :fats, :carbohydrates
  translates :name
  belongs_to :product_category

  def self.by_lang(lang)
    connection.select_all(
      "SELECT p.id, p.product_category_id, pt.name FROM menu_products p
      JOIN menu_product_translations pt ON pt.menu_product_id = p.id
      WHERE pt.locale = #{quote_value(lang)}")
  end
end
