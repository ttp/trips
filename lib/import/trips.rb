require 'csv'

module Import
  class Trips
    def initialize(user_id)
      @user = User.find(user_id)
      @logger = Logger.new(STDOUT)
    end

    def import_tracks(filename)
      CSV.foreach(filename, :headers => true) do |row|
        track_name = row.field("name")
        track_name.strip!

        if get_track(track_name).nil?
          region = Region.find_by_name(row.field('region'))
          @logger.debug('region not found ' + row.field('region')) if region.nil?
          next if region.nil?

          track = Track.new
          track.name = track_name
          track.user_id = @user.id
          track.region_id = region.id
          track.track = row.field('track')
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
          @logger.debug('track not found, goto next row')
          next
        end

        if get_trip(track_row.id, row.field('start_date'), row.field('end_date')).nil?
          @logger.debug('creating trip ' + track_row.name)
          trip = Trip.new
          trip.track_id = track_row.id
          trip.user_id = @user.id
          trip.start_date = row.field('start_date')
          trip.end_date = row.field('end_date')
          trip.url = row.field('url')
          trip.has_guide = (row.field('has_guide') == "yes")
          trip.available_places = row.field('available_places').to_i
          if !trip.save
            console.debug(trip.errors)
          end
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
end