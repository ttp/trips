class AddFoodCalculatorTables < ActiveRecord::Migration
  def up
    create_table :menu_menus do |t|
      t.references :user
      t.string :name, :null => false, :default => ''
      t.integer :users_count, :null => false, :default => 1
      t.integer :days_count, :null => false, :default => 0
      t.decimal :coverage, :null => false, :default => 0, precision: 5, scale: 2
      t.boolean :is_public, :default => false

      t.timestamps
    end

    create_table :menu_days do |t|
      t.references :menu
      t.integer :num
      t.decimal :rate, :null => false, :default => 1, precision: 3, scale: 2
    end

    create_table :menu_day_entities do |t|
      t.integer :parent_id
      t.references :day
      t.integer :entity_type, :null => false, :limit => 1
      t.integer :entity_id, :null => false
      t.integer :weight, :null => false, :default => 0
    end

    create_table :menu_dish_categories do |t|
    end
    Menu::DishCategory.create_translation_table! :name => :string

    create_table :menu_dishes do |t|
      t.references :dish_category
    end
    Menu::Dish.create_translation_table! :name => :string

    create_table :menu_meals do |t|
    end
    Menu::Meal.create_translation_table! :name => :string

    create_table :menu_product_categories do |t|
    end
    Menu::ProductCategory.create_translation_table! :name => :string

    create_table :menu_products do |t|
      t.references :product_category, :null => false
      t.integer :calories, :null => false, :default => 0
      t.integer :proteins, :null => false, :default => 0
      t.integer :fats, :null => false, :default => 0
      t.integer :carbohydrates, :null => false, :default => 0
    end
    Menu::Product.create_translation_table! :name => :string

    create_table :menu_dish_products do |t|
      t.references :dish
      t.references :product
      t.integer :weight
    end
  end

  def down
    drop_table :menu_menus
    drop_table :menu_days
    drop_table :menu_day_entities
    drop_table :menu_dish_categories
    Menu::DishCategory.drop_translation_table!
    drop_table :menu_dishes
    Menu::Dish.drop_translation_table!
    drop_table :menu_meals
    Menu::Meal.drop_translation_table!
    drop_table :menu_product_categories
    Menu::ProductCategory.drop_translation_table!
    drop_table :menu_products
    Menu::Product.drop_translation_table!
    drop_table :menu_dish_products
  end
end
