class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      t.text :track, :null => false
      t.string :url, :null => false

      t.timestamps
    end
  end
end
