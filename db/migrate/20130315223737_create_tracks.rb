class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.text :description
      t.string :track
      t.string :details_url

      t.timestamps
    end
  end
end
