class RenameTrackDetailsUrl < ActiveRecord::Migration
  def change
    rename_column :tracks, :details_url, :url
  end
end
