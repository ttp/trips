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
    @track = @trip.track
    @region = @track.region

    
  end
end
