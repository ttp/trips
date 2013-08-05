require 'csv'

puts 'Menu dishes'
Menu::Dish.translation_class.delete_all
Menu::Dish.delete_all
Menu::DishCategory.translation_class.delete_all
Menu::DishCategory.delete_all

category = dish = nil
locales = [:ru,:ua]
filename = File.expand_path('../menu_dishes.csv', __FILE__)
CSV.foreach(filename, :headers => true) do |row|
  if row.field('type') == '1'
    category = Menu::DishCategory.new
    locales.each do |locale|
      Globalize.with_locale(locale) do
        category.name = row.field(locale.to_s)
      end
    end
    category.save
  else
    dish = category.dishes.create
    locales.each do |locale|
      Globalize.with_locale(locale) do
        dish.name = row.field(locale.to_s)
      end
    end
    dish.save
  end
end