class TripComment < ActiveRecord::Base
  attr_accessible :comment

  def self.with_users(trip_id)
    connection.select_all(
      "SELECT tc.*, u.name, u.email
      FROM trip_comments tc
      INNER JOIN users u ON u.id = tc.user_id
      WHERE tc.trip_id=#{quote_value(trip_id)}")
  end

  def self.with_users_hash(trip_id)
    connection.select_all(
      "SELECT tc.*, u.name, u.email_hash
      FROM trip_comments tc
      INNER JOIN users u ON u.id = tc.user_id
      WHERE tc.trip_id=#{quote_value(trip_id)}")
  end
end
