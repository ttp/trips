require 'csv'

class ImportService
  def initialize(user_id)
    @user = User.find(user_id)
  end

  def import_tracks(filename)
    CSV.foreach(filename, :headers => true) do |row|
      track_name = row.field("name")
      track_name.strip!

      if get_track(track_name).nil?
        region = Region.find_by_name(row.field('region'))
        track = Track.new
        track.name = track_name
        track.user_id = @user.id
        track.region_id = region.id
        track.save
      end
    end
  end

  def import_trips(filename)
    CSV.foreach(filename, :headers => true) do |row|
      track_name = row.field("name")
      track_name.strip!

      track_row = get_track(track_name)
      if track_row.nil?
        next
      end

      if get_trip(track_row.id, row.field('start_date'), row.field('end_date')).nil?
        track = Trip.new
        track.track_id = track_row.id
        track.user_id = @user.id
        track.start_date = row.field('start_date')
        track.end_date = row.field('end_date')
        track.save
      end
    end
  end

  def get_trip(track_id, start_date, end_date)
    Trip.where("user_id = ?", @user.id)
        .where("track_id = ?", track_id)
        .where("start_date = ?", start_date)
        .where("end_date = ?", end_date).first
  end

  def get_track(name)
    Track.where("user_id = ?", @user.id).where("name = ?", name).first
  end
end