class AddFoodCalculatorTables < ActiveRecord::Migration[4.2]
  def up
    create_table :menu_menus do |t|
      t.references :user
      t.string :name, :null => false, :default => ''
      t.string :read_key, :null => false, :default => ''
      t.string :edit_key, :null => false, :default => ''
      t.integer :users_count, :null => false, :default => 1
      t.integer :days_count, :null => false, :default => 0
      t.decimal :coverage, :null => false, :default => 0, precision: 5, scale: 2
      t.boolean :is_public, :default => false

      t.timestamps
    end
    add_index :menu_menus, :user_id
    add_index :menu_menus, :is_public

    create_table :menu_days do |t|
      t.references :menu
      t.integer :num
      t.decimal :coverage, :null => false, :default => 0, precision: 3, scale: 2
    end
    add_index :menu_days, :menu_id

    create_table :menu_day_entities do |t|
      t.integer :parent_id
      t.references :day
      t.integer :entity_type, :null => false, :limit => 1
      t.integer :entity_id, :null => false
      t.integer :weight, :null => false, :default => 0
      t.integer :sort_order, :null => false, :default => 0
    end
    add_index :menu_day_entities, :day_id

    create_table :menu_dish_categories do |t|
    end
    create_table "menu_dish_category_translations", force: :cascade do |t|
      t.integer  "menu_dish_category_id",             null: false
      t.string   "locale",                limit: 255, null: false
      t.string   "name",                  limit: 255
    end

    create_table :menu_dishes do |t|
      t.references :dish_category
    end
    create_table "menu_dish_translations" do |t|
      t.integer  "menu_dish_id",             null: false
      t.string   "locale",                limit: 255, null: false
      t.string   "name",                  limit: 255
    end

    create_table :menu_meals do |t|
    end
    create_table "menu_meal_translations" do |t|
      t.integer  "menu_meal_id",             null: false
      t.string   "locale",                limit: 255, null: false
      t.string   "name",                  limit: 255
    end

    create_table :menu_product_categories do |t|
    end
    create_table "menu_product_category_translations" do |t|
      t.integer  "menu_product_category_id",             null: false
      t.string   "locale",                limit: 255, null: false
      t.string   "name",                  limit: 255
    end

    create_table :menu_products do |t|
      t.references :product_category, :null => false
      t.integer :calories, :null => false, :default => 0
      t.integer :proteins, :null => false, :default => 0
      t.integer :fats, :null => false, :default => 0
      t.integer :carbohydrates, :null => false, :default => 0
    end
    create_table "menu_product_translations" do |t|
      t.integer  "menu_product_id",             null: false
      t.string   "locale",                limit: 255, null: false
      t.string   "name",                  limit: 255
    end

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
    drop_table :menu_dish_category_translations
    drop_table :menu_dishes
    drop_table :menu_dish_translations
    drop_table :menu_meals
    drop_table :menu_meal_translations
    drop_table :menu_product_categories
    drop_table :menu_product_category_translations
    drop_table :menu_products
    drop_table :menu_product_translations
    drop_table :menu_dish_products
  end
end
