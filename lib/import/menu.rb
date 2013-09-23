require 'csv'

module Import
  class Menu
    LOCALES = [:ru,:ua]

    def import_products(filename)
      category = nil
      CSV.foreach(filename, :headers => true) do |row|
        if row.field('category') == '1'
          category = ::Menu::ProductCategory.new
          LOCALES.each do |locale|
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
          LOCALES.each do |locale|
            Globalize.with_locale(locale) do
              product.name = row.field(locale.to_s)
            end
          end
          product.save
        end
      end
    end

    def import_dishes(filename)
      category = dish = nil
      CSV.foreach(filename, :headers => true) do |row|
        if row.field('type') == '1'
          category = ::Menu::DishCategory.new
          LOCALES.each do |locale|
            Globalize.with_locale(locale) do
              category.name = row.field(locale.to_s)
            end
          end
          category.save
        elsif row.field('type') == '2'
          dish = category.dishes.create
          LOCALES.each do |locale|
            Globalize.with_locale(locale) do
              dish.name = row.field(locale.to_s)
            end
          end
          dish.save
        else
          product = nil
          LOCALES.each do |locale|
            if row.field(locale.to_s) != ""
              products = ::Menu::Product.with_translations(locale).where("name = ?", row.field(locale.to_s))
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
    end

    def import_meals(filename)
      CSV.foreach(filename, :headers => true) do |row|
        meal = ::Menu::Meal.new
        LOCALES.each do |locale|
          Globalize.with_locale(locale) do
            meal.name = row.field(locale.to_s)
          end
        end
        meal.id = row.field('id')
        meal.save
      end
    end

    def clean
      ::Menu::DayEntity.delete_all
      ::Menu::Day.delete_all
      ::Menu::Menu.delete_all

      ::Menu::Dish.translation_class.delete_all
      ::Menu::Dish.delete_all
      ::Menu::DishCategory.translation_class.delete_all
      ::Menu::DishCategory.delete_all
      ::Menu::DishProduct.delete_all

      ::Menu::Product.translation_class.delete_all
      ::Menu::Product.delete_all
      ::Menu::ProductCategory.translation_class.delete_all
      ::Menu::ProductCategory.delete_all

      ::Menu::Meal.translation_class.delete_all
      ::Menu::Meal.delete_all
    end
  end
end