class AddUserDescriptionToDish < ActiveRecord::Migration
  def up
    Menu::Dish.add_translation_fields!({
      description: :text
    })
    add_column :menu_dishes, :icon, :string, :null => false, :default => ''
    add_column :menu_dishes, :user_id, :integer
    add_column :menu_dishes, :is_public, :boolean, null: false, default: false
    Menu::Dish.update_all is_public: true

    add_column :menu_dish_products, :sort_order, :integer, null: false, default: 0
  end

  def down
    remove_columns :menu_dishes, :icon, :user_id, :is_public
    remove_columns :menu_dish_translations, :description
  end
end
