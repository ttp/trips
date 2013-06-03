class ChangeTrackDefaultValues < ActiveRecord::Migration
  def up
  	change_column :tracks, :description, :text, :default => ''
  	change_column :tracks, :track, :text, :default => ''
  	change_column :tracks, :url, :string, :default => ''
  end

  def down
  end
end
