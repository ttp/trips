module TripsHelper
  def trip_url(trip, track)
    return trip.url if !trip.url.nil? && !trip.url.empty?
    return track.url if !track.url.nil? && !track.url.empty?
    false
  end
end
