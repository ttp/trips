class AddUserIndexes < ActiveRecord::Migration[4.2]
  def change
    add_index :tracks, :region_id
    add_index :tracks, :user_id
    
    add_index :trips, :user_id
    add_index :trips, :start_date

    add_index :trip_comments, :trip_id

    add_index :trip_users, :trip_id
    add_index :trip_users, :user_id

    add_index :users, :authentication_token
  end
end
