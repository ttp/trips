class Account::TripsController < ApplicationController
  before_filter :authenticate_user!

  def initialize
    super
    @sortable_fields = {
        "id"     => "trips.id",
        "track" => "track_id",
        "start_date"   => "start_date",
        "region"   => "region_id"
    }
    @default_sort = 'trips.id desc'
  end

  # GET /trips
  # GET /trips.json
  def index
    @trips = Trip.joins(:track).includes(:track => [:region]).where("trips.user_id = ?", current_user.id)
                 .paginate(:page => params[:page], :per_page => 10).order(order)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    @trip = Trip.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    @trip = Trip.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
    redirect_to account_trips_url and return if @trip.user_id != current_user.id
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])
    @trip.user_id = current_user.id

    respond_to do |format|
      if @trip.save
        format.html { redirect_to back(account_trips_url), notice: I18n.t('account.trip.was_created') }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    @trip = Trip.find(params[:id])
    redirect_to account_trips_url and return if @trip.user_id != current_user.id

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to back(account_trips_url), notice: I18n.t('account.trip.was_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip = Trip.find(params[:id])
    redirect_to account_trips_url and return if @trip.user_id != current_user.id
    @trip.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || account_trips_url }
      format.json { head :no_content }
    end
  end
end
