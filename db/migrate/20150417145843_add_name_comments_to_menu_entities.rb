class AddNameCommentsToMenuEntities < ActiveRecord::Migration
  def change
    add_column :menu_day_entities, :custom_name, :string
    add_column :menu_day_entities, :notes, :string
    add_column :menu_days, :notes, :string
    add_column :menu_menus, :notes, :text
  end
end
