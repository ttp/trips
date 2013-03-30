class TripsController < ApplicationController
  def index
    @trips = Trip.latest
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
end
