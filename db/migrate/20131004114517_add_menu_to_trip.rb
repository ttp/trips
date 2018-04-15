class AddMenuToTrip < ActiveRecord::Migration[4.2]
  def change
    add_column :trips, :menu_id, :integer
  end
end
