class ChangeTrackDefaultValues < ActiveRecord::Migration[4.2]
  def up
  	change_column :tracks, :url, :string, :default => ''
  end

  def down
  end
end
