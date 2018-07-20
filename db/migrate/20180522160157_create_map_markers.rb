class CreateMapMarkers < ActiveRecord::Migration[5.1]
  def change
    create_table :map_markers do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lng
      t.string :type
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
