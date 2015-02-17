require 'csv'

module Import
  class Trips
    def initialize(user_id)
      @user = User.find(user_id)
      @logger = Logger.new(STDOUT)
    end

    def import_tracks(filename)
      CSV.foreach(filename, headers: true) do |row|
        track_name = row.field('name')
        track_name.strip!
        next unless get_track(track_name).nil?

        region = Region.find_by_name(row.field('region'))
        @logger.debug('region not found ' + row.field('region')) if region.nil?
        next if region.nil?

        create_track(region, row, track_name)
      end
    end

    def create_track(region, row, track_name)
      track = Track.new
      track.description = ''
      track.name = track_name
      track.user_id = @user.id
      track.region_id = region.id
      track.track = row.field('track')
      track.save
    end

    def import_trips(filename)
      CSV.foreach(filename, headers: true) do |row|
        track_name = row.field('name')
        track_name.strip!

        track_row = get_track(track_name)
        if track_row.nil?
          @logger.debug("track not found #{track_name}, goto next row")
          next
        end

        next if get_trip(track_row.id, row.field('start_date'), row.field('end_date'))
        create_trip(row, track_row)
      end
    end

    def create_trip(row, track_row)
      trip = Trip.create track_id: track_row.id,
                         user_id: @user.id,
                         start_date: row.field('start_date'),
                         end_date: row.field('end_date'),
                         url: row.field('url'),
                         has_guide: row.field('has_guide') == 'yes',
                         available_places: row.field('available_places').to_i,
                         trip_details: ''
      @logger.debug(trip.errors) if trip.errors.present?
    end

    def get_trip(track_id, start_date, end_date)
      Trip.where('user_id = ?', @user.id)
        .where('track_id = ?', track_id)
        .where('start_date = ?', start_date)
        .where('end_date = ?', end_date)
        .first
    end

    def get_track(name)
      Track.where('user_id = ?', @user.id).where('name = ?', name).first
    end
  end
end
