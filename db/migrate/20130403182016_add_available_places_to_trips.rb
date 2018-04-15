class AddAvailablePlacesToTrips < ActiveRecord::Migration[4.2]
  def up
    add_column :trips, :available_places, :integer
    Trip.update_all({available_places: 10})
    change_column :trips, :available_places, :integer, null: false
  end

  def down
    remove_column :trips, :available_places
  end
end
