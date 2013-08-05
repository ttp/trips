class Menu::Meal < ActiveRecord::Base
  attr_accessible :name
  translates :name

  def self.by_lang(lang)
    connection.select_all(
      "SELECT m.id, mt.name FROM menu_meals m
      JOIN menu_meal_translations mt ON mt.menu_meal_id = m.id
      WHERE mt.locale = #{quote_value(lang)}")
  end
end