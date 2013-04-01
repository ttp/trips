class ChangeTrackTrackType < ActiveRecord::Migration
  def change
    change_column :tracks, :track, :text
  end
end
