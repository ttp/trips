class AddUserIds < ActiveRecord::Migration
  def change
    add_column :tracks, :user_id, :integer
    add_column :trips, :user_id, :integer
  end
end
