class TripUser < ActiveRecord::Base
  attr_accessible :user_id, :trip_id, :approved
end
