class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name

      t.timestamps
    end
    add_column :tracks, :region_id, :integer
  end
end
