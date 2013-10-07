class AddMenuToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :menu_id, :integer
  end
end
