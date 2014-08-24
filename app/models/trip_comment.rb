class TripComment < ActiveRecord::Base
  attr_accessible :comment
  belongs_to :user
  belongs_to :trip

  def self.with_users(trip_id)
    rows = connection.select_all(
      "SELECT tc.*, u.name, u.email
      FROM trip_comments tc
      INNER JOIN users u ON u.id = tc.user_id
      WHERE tc.trip_id=#{connection.quote(trip_id)}")
    rows.each {|row| row['created_at'] = row['created_at'].to_time}
    rows
  end

  def self.with_users_hash(trip_id)
    connection.select_all(
      "SELECT tc.*, u.name, u.email_hash
      FROM trip_comments tc
      INNER JOIN users u ON u.id = tc.user_id
      WHERE tc.trip_id=#{connection.quote(trip_id)}")
  end
end
