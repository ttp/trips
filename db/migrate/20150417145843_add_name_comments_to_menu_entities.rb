class AddNameCommentsToMenuEntities < ActiveRecord::Migration[4.2]
  def change
    add_column :menu_day_entities, :custom_name, :string
    add_column :menu_day_entities, :notes, :string
    add_column :menu_days, :notes, :string
    add_column :menu_menus, :description, :text
  end
end
