require 'csv'

puts 'Menu dishes'
Menu::Dish.translation_class.delete_all
Menu::Dish.delete_all
Menu::DishCategory.translation_class.delete_all
Menu::DishCategory.delete_all
Menu::DishProduct.delete_all

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
  elsif row.field('type') == '2'
    dish = category.dishes.create
    locales.each do |locale|
      Globalize.with_locale(locale) do
        dish.name = row.field(locale.to_s)
      end
    end
    dish.save
  else
    product = nil
    locales.each do |locale|
      if row.field(locale.to_s) != ""
        products = Menu::Product.with_translations(locale).where("name = ?", row.field(locale.to_s))
        product = products[0] if products.size > 0
        break
      end
    end
    unless product.nil?
      dish_product = dish.dish_products.create
      dish_product.product = product
      dish_product.weight = row.field('weight').to_i
      dish_product.save
    end
  end
end