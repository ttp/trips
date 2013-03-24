require 'date'

class Trip < ActiveRecord::Base
  attr_accessible :track_id, :dates_range, :end_date, :start_date, :trip_details, :price, :url
  belongs_to :track

  validates :track_id, :dates_range, :presence => true

  def dates_range
    (I18n.l(start_date) + " - " + I18n.l(end_date)) unless (start_date.nil? || end_date.nil?)
  end

  def dates_range=(value)
    self.start_date, self.end_date = value.split(" - ")
  end

  def self.latest
    connection.select_all(
      "SELECT trips.id, trips.start_date, trips.end_date, trips.track_id, tracks.name as track_name,
        regions.name as region_name
      FROM trips
      INNER JOIN tracks ON trips.track_id = tracks.id
      INNER JOIN regions ON tracks.region_id = regions.id
      WHERE trips.start_date >= #{quote_value(DateTime.now.to_date.to_s)}")
  end
end