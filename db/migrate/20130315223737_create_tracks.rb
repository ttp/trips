class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name, :null => false
      t.text :description
      t.text :track
      t.string :url, :null => false

      t.timestamps
    end
  end
end
