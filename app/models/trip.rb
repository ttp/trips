require 'date'

class Trip < ActiveRecord::Base
  belongs_to :track
  belongs_to :user
  belongs_to :menu_menu, :class_name => 'Menu::Menu', :foreign_key => :menu_id
  has_many :trip_users
  has_many :trip_comments

  validates :track_id, :dates_range, :available_places, :presence => true

  before_save :cache_duration

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
      "SELECT trips.id, trips.start_date, trips.end_date, trips.cached_duration, trips.track_id, trips.has_guide,
        tracks.name as track_name,
        regions.name as region_name,
        trips.user_id, users.name as user_name
      FROM trips
      INNER JOIN tracks ON trips.track_id = tracks.id
      INNER JOIN regions ON tracks.region_id = regions.id
      INNER JOIN users ON users.id = trips.user_id
      WHERE trips.start_date BETWEEN #{connection.quote(start_str)} AND #{connection.quote(end_str)}")
  end

  def self.upcoming(num)
    start_str = Time.now.strftime('%Y-%m-%d')

    connection.select_all(
      "SELECT trips.id, trips.start_date, trips.end_date, trips.track_id, trips.has_guide,
        tracks.name as track_name,
        regions.name as region_name,
        trips.user_id, users.name as user_name
      FROM trips
      INNER JOIN tracks ON trips.track_id = tracks.id
      INNER JOIN regions ON tracks.region_id = regions.id
      INNER JOIN users ON users.id = trips.user_id
      WHERE trips.start_date > #{connection.quote(start_str)}
      ORDER BY trips.start_date
      LIMIT #{num}")
  end

  def self.scheduled(user_id)
    start_str = Time.now.strftime('%Y-%m-%d')
    Trip.joins(:track).includes(:track => [:region])
        .joins(:trip_users)
        .where('trip_users.user_id = ?', user_id)
        .where('trips.start_date > ?', start_str)
        .order('trips.start_date')
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

  def cache_duration
    duration = (self.end_date.to_time - self.start_date.to_time).to_i + 1.day.to_i
    self.cached_duration = (duration / 86400).round
  end
end
