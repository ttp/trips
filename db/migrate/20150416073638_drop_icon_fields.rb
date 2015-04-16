class DropIconFields < ActiveRecord::Migration
  def change
    remove_column :menu_products, :icon, :string, null: false, default: ''
    remove_column :menu_dishes, :icon, :string, null: false, default: ''
  end
end
