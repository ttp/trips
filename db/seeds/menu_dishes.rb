require 'csv'

puts 'Menu products'
Menu::Product.translation_class.delete_all
Menu::Product.delete_all
Menu::ProductCategory.translation_class.delete_all
Menu::ProductCategory.delete_all

category = product = nil
locales = [:ru,:ua]
filename = File.expand_path('../menu_products.csv', __FILE__)
CSV.foreach(filename, :headers => true) do |row|
  if row.field('category') == '1'
    category = Menu::ProductCategory.new
    locales.each do |locale|
      Globalize.with_locale(locale) do
        category.name = row.field(locale.to_s)
      end
    end
    category.save
  else
    product = category.products.create
    product.calories = row.field('calories')
    product.proteins = row.field('proteins')
    product.fats = row.field('fats')
    product.carbohydrates = row.field('carbohydrates')
    locales.each do |locale|
      Globalize.with_locale(locale) do
        product.name = row.field(locale.to_s)
      end
    end
    product.save
  end
end