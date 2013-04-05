class TripsController < ApplicationController
  before_filter :authenticate_user!, :only => [:join]

  def index
    @trips = Trip.for_year
    render json: @trips and return

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  def show
    @trip = Trip.find(params[:id])
    @joined_users = @trip.joined_users
    @want_to_join_users = @trip.want_to_join_users
    @track = @trip.track
    @region = @track.region
  end

  # POST /trips/1/join
  # POST /trips/1/join.json
  def join
    trip = Trip.find(params[:id])
    trip_url = "/trips/#{trip.id}"

    if trip.available_places == 0
      respond_to do |format|
        format.html { redirect_to trip_url, flash: {error: t("trip.no_available_places")} }
        format.json { render json: {error: t("trip.no_available_places")} }
      end
      return
    end

    if !trip.user_can_join?(current_user.id)
      respond_to do |format|
        format.html { redirect_to trip_url, flash: {error: t("trip.already_joined")} }
        format.json { render json: {error: t("trip.already_joined")}, status: :unprocessable_entity }
      end
      return
    end

    trip.trip_users.create({user_id: current_user.id, approved: false})
    respond_to do |format|
      format.html { redirect_to trip_url, :notice => t("trip.join_request_added") }
      format.json { head :ok }
    end
  end
end
