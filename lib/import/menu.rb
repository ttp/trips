require 'csv'

module Import
  class Menu
    LOCALES = [:ru, :ua]

    def import_products(filename)
      category = nil
      CSV.foreach(filename, headers: true) do |row|
        if row.field('category') == '1'
          category = create_product_category(row)
        else
          create_product(category, row)
        end
      end
    end

    def create_product(category, row)
      product = category.products.build calories: row.field('calories'),
                                        proteins: row.field('proteins'),
                                        fats: row.field('fats'),
                                        carbohydrates: row.field('carbohydrates'),
                                        is_public: true
      LOCALES.each do |locale|
        Globalize.with_locale(locale) do
          product.name = row.field(locale.to_s)
        end
      end
      product.save
      product
    end

    def create_product_category(row)
      category = ::Menu::ProductCategory.new
      LOCALES.each do |locale|
        Globalize.with_locale(locale) do
          category.name = row.field(locale.to_s)
        end
      end
      category.save
      category
    end

    def import_dishes(filename)
      category = dish = nil
      CSV.foreach(filename, headers: true) do |row|
        if row.field('type') == '1'
          category = create_product_category(row)
        elsif row.field('type') == '2'
          dish = create_dish(category, row)
        else
          product = find_product(row)
          create_dish_product(dish, product, row) unless product.nil?
        end
      end
    end

    def find_product(row)
      product = nil
      LOCALES.each do |locale|
        next unless row.field(locale.to_s) != ''
        products = ::Menu::Product.with_translations(locale).where('name = ?', row.field(locale.to_s))
        product = products[0] if products.size > 0
        break
      end
      product
    end

    def create_dish_product(dish, product, row)
      dish_product = dish.dish_products.build
      dish_product.product = product
      dish_product.weight = row.field('weight').to_i
      dish_product.save
    end

    def create_dish(category, row)
      dish = category.dishes.build is_public: true
      LOCALES.each do |locale|
        Globalize.with_locale(locale) do
          dish.name = row.field(locale.to_s)
        end
      end
      dish.save
      dish
    end

    def import_meals(filename)
      CSV.foreach(filename, headers: true) do |row|
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
      clean_menus
      clean_dishes
      clean_products
      clean_meals
    end

    def clean_meals
      ::Menu::Meal.translation_class.delete_all
      ::Menu::Meal.delete_all
    end

    def clean_products
      ::Menu::Product.translation_class.delete_all
      ::Menu::Product.delete_all
      ::Menu::ProductCategory.translation_class.delete_all
      ::Menu::ProductCategory.delete_all
    end

    def clean_dishes
      ::Menu::Dish.translation_class.delete_all
      ::Menu::Dish.delete_all
      ::Menu::DishCategory.translation_class.delete_all
      ::Menu::DishCategory.delete_all
      ::Menu::DishProduct.delete_all
    end

    def clean_menus
      ::Menu::DayEntity.delete_all
      ::Menu::Day.delete_all
      ::Menu::Menu.delete_all
    end
  end
end
