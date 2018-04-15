class CreateTracks < ActiveRecord::Migration[4.2]
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
