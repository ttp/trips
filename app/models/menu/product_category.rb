class Menu::ProductCategory < ActiveRecord::Base
  attr_accessible :name
  has_many :products
  translates :name
  class Translation
    attr_accessible :locale
  end

  def self.by_lang(lang)
  	connection.select_all(
  		"SELECT pc.id, pct.name FROM menu_product_categories pc
  		JOIN menu_product_category_translations pct ON pct.menu_product_category_id = pc.id
  		WHERE pct.locale = #{quote_value(lang)}")
  end
end
