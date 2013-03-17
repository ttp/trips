class Trip < ActiveRecord::Base
  attr_accessible :track_id, :dates_range, :end_date, :start_date, :trip_details
  belongs_to :track

  def dates_range
    start_date.to_s + "-" + end_date.to_s unless (start_date.nil? && end_date.nil?)
  end

  def dates_range=(value)
    self.start_date, self.end_date = value.split(" - ")
  end
end
