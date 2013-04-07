require 'date'

class Trip < ActiveRecord::Base
  attr_accessible :track_id, :dates_range, :end_date, :start_date, :trip_details, :price, :url, :available_places
  belongs_to :track
  belongs_to :user
  has_many :trip_users

  validates :track_id, :dates_range, :available_places, :presence => true

  def dates_range
    (I18n.l(start_date) + " - " + I18n.l(end_date)) unless (start_date.nil? || end_date.nil?)
  end

  def dates_range=(value)
    self.start_date, self.end_date = value.split(" - ")
  end

  def self.for_year
    start_at = Time.now
    end_at = Time.new(start_at.year + 1, start_at.month, 1)
    connection.select_all(
      "SELECT trips.id, trips.start_date, trips.end_date, trips.track_id, tracks.name as track_name,
        regions.name as region_name
      FROM trips
      INNER JOIN tracks ON trips.track_id = tracks.id
      INNER JOIN regions ON tracks.region_id = regions.id
      WHERE trips.start_date BETWEEN #{quote_value(start_at.to_date.to_s)} AND #{quote_value(end_at.to_date.to_s)}")
  end

  def joined_users
    users.where("trip_users.approved = ?", true)
  end

  def want_to_join_users
    users.where("trip_users.approved = ?", false)
  end

  def users
    User.joins("join trip_users on trip_users.user_id = users.id")
      .where("trip_users.trip_id = #{self.id}")
  end

  def user_can_join?(user_id)
      users.where("users.id = ?", user_id).count() == 0 && available_places > 0
  end
end