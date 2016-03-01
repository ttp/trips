class RenameUaLocale < ActiveRecord::Migration
  def up
    execute "UPDATE menu_dish_translations SET locale='uk' WHERE locale='ua'"
    execute "UPDATE menu_dish_category_translations SET locale='uk' WHERE locale='ua'"
    execute "UPDATE menu_meal_translations SET locale='uk' WHERE locale='ua'"
    execute "UPDATE menu_product_translations SET locale='uk' WHERE locale='ua'"
    execute "UPDATE menu_product_category_translations SET locale='uk' WHERE locale='ua'"
  end

  def down
    execute "UPDATE menu_dish_translations SET locale='ua' WHERE locale='uk'"
    execute "UPDATE menu_dish_category_translations SET locale='ua' WHERE locale='uk'"
    execute "UPDATE menu_meal_translations SET locale='ua' WHERE locale='uk'"
    execute "UPDATE menu_product_translations SET locale='ua' WHERE locale='uk'"
    execute "UPDATE menu_product_category_translations SET locale='ua' WHERE locale='uk'"
  end
end
