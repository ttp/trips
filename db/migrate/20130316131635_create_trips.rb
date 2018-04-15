class CreateTrips < ActiveRecord::Migration[4.2]
  def change
    create_table :trips do |t|
      t.references :track
      t.date :start_date, :null => false
      t.date :end_date, :null => false
      t.text :trip_details

      t.timestamps
    end
  end
end
