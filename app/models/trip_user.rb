class TripUser < ActiveRecord::Base
  attr_accessible :user_id, :trip_id, :approved
  belongs_to :trip
  before_destroy :update_available_places

  def self.find_request(trip_id, user_id)
    where({trip_id: trip_id, user_id: user_id}).first
  end

  def update_available_places
    if approved
      trip.available_places = trip.available_places + 1
      trip.save
    end
  end
end
