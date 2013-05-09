require 'date'

class Trip < ActiveRecord::Base
  attr_accessible :track_id, :dates_range, :end_date, :start_date, :trip_details, :has_guide, :url, :available_places
  belongs_to :track
  belongs_to :user
  has_many :trip_users
  has_many :trip_comments

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

    start_str = start_at.strftime('%Y-%m-') + '00'
    end_str = end_at.strftime('%Y-%m-') + '00'

    connection.select_all(
      "SELECT trips.id, trips.start_date, trips.end_date, trips.track_id, trips.has_guide,
        tracks.name as track_name,
        regions.name as region_name
      FROM trips
      INNER JOIN tracks ON trips.track_id = tracks.id
      INNER JOIN regions ON tracks.region_id = regions.id
      WHERE trips.start_date BETWEEN #{quote_value(start_str)} AND #{quote_value(end_str)}")
  end

  def self.upcoming(num)
    start_str = Time.now.strftime('%Y-%m-%d')

    connection.select_all(
      "SELECT trips.id, trips.start_date, trips.end_date, trips.track_id, trips.has_guide,
        tracks.name as track_name,
        regions.name as region_name
      FROM trips
      INNER JOIN tracks ON trips.track_id = tracks.id
      INNER JOIN regions ON tracks.region_id = regions.id
      WHERE trips.start_date > #{quote_value(start_str)}
      ORDER BY trips.id
      LIMIT #{num}")
  end

  def self.scheduled(user_id)
    start_str = Time.now.strftime('%Y-%m-%d')
    Trip.joins(:track).includes(:track => [:region])
        .joins(:trip_users)
        .where('trip_users.user_id = ?', user_id)
        .where('trips.start_date > ?', start_str)
  end

  def self.archive(user_id)
    start_str = Time.now.strftime('%Y-%m-%d')
    Trip.joins(:track).includes(:track => [:region])
        .joins(:trip_users)
        .where('trip_users.user_id = ?', user_id)
        .where('trips.start_date <= ?', start_str)
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