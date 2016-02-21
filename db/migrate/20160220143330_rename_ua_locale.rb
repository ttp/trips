class RenameUaLocale < ActiveRecord::Migration
  def up
    Menu::Dish::Translation.where(locale: 'ua').update_all(locale: 'uk')
    Menu::DishCategory::Translation.where(locale: 'ua').update_all(locale: 'uk')
    Menu::Meal::Translation.where(locale: 'ua').update_all(locale: 'uk')
    Menu::Product::Translation.where(locale: 'ua').update_all(locale: 'uk')
    Menu::ProductCategory::Translation.where(locale: 'ua').update_all(locale: 'uk')
  end

  def down
    Menu::Dish::Translation.where(locale: 'uk').update_all(locale: 'ua')
    Menu::DishCategory::Translation.where(locale: 'uk').update_all(locale: 'ua')
    Menu::Meal::Translation.where(locale: 'uk').update_all(locale: 'ua')
    Menu::Product::Translation.where(locale: 'uk').update_all(locale: 'ua')
    Menu::ProductCategory::Translation.where(locale: 'uk').update_all(locale: 'ua')
  end
end
