class AddUserToProduct < ActiveRecord::Migration[4.2]
  def up
    add_column :menu_products, :user_id, :integer
    add_column :menu_products, :is_public, :boolean, null: false, default: false
    Menu::Product.update_all is_public: true
  end

  def down
    remove_column :menu_products, :user_id
    remove_column :menu_products, :is_public
  end
end
