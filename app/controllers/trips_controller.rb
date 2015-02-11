class TripsController < ApplicationController
  before_filter :authenticate_user!, :only => [:join, :leave, :decline, :approve]

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
    @comments = TripComment.with_users(@trip.id)
    if @trip.menu_id
      @menu = @trip.menu_menu
      if @menu
        @menu.users_count = @joined_users.count > 0 ? @joined_users.count : 1
      end
    end
  end

  # POST /trips/1/join
  # POST /trips/1/join.json
  def join
    trip = Trip.find(params[:id])
    trip_url = "/trips/#{trip.id}"

    if trip.available_places == 0
      respond_to do |format|
        format.html { redirect_to trip_url, flash: {error: t("trip.no_available_places")} }
        format.json { render json: {error: t("trip.no_available_places"), status: :unprocessable_entity} }
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
    TripJoinMailer.join_request_user_email(current_user, trip).deliver_now
    TripJoinMailer.join_request_owner_email(current_user, trip).deliver_now

    respond_to do |format|
      format.html { redirect_to trip_url, :notice => t("trip.join_request_added") }
      format.json { render json: {status: :ok}, status: :ok }
    end
  end

  # POST /trips/1/leave
  def leave
    request = TripUser.find_request(params[:id], current_user.id)
    if request
      request.destroy
      TripJoinMailer.leave_email(current_user, request.trip).deliver_now
    end
    render json: {status: :ok, available_places: request.trip.available_places}
  end

  # POST /trips/1/decline/:user_id
  def decline
    request = TripUser.find_request(params[:id], params[:user_id])
    if request
      if request.trip.user_id != current_user.id
        render json: {status: :not_trip_owner}, status: :unprocessable_entity and return
      end
      user = request.user
      trip = request.trip
      request.destroy
      TripJoinMailer.decline_email(user, trip, params[:message]).deliver_now
    end
    render json: {status: :ok, available_places: trip.available_places}, status: :ok
  end

  # POST /trips/1/approve/:user_id
  def approve
    request = TripUser.find_request(params[:id], params[:user_id])
    if request
      if request.trip.user_id != current_user.id
        render json: {status: :not_trip_owner}, status: :unprocessable_entity and return
      end
      request.approved = true
      request.save
      trip = request.trip
      if trip.available_places > 0
        trip.available_places -= 1
        trip.save
      end
      TripJoinMailer.approve_email(request.user, trip).deliver_now
    end
    render json: {status: :ok, available_places: trip.available_places}, status: :ok
  end
end
