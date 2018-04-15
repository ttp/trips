class AddDescriptionToMenuProduct < ActiveRecord::Migration[4.2]
  def up
    add_column :menu_product_translations, :description, :text
    add_column :menu_product_translations, :norm_info, :text
    add_column :menu_products, :icon, :string, :null => false, :default => ''
    add_column :menu_products, :norm, :integer, :null => false, :default => 0
  end

  def down
    remove_columns :menu_products, :norm, :icon
    remove_columns :menu_product_translations, :description, :norm_info
  end
end
