class Account::TripsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_trip, only: [:edit, :update, :destroy]

  def initialize
    super
    @sortable_fields = { "id"     => "trips.id",
                         "track" => "track_id",
                         "start_date"   => "start_date",
                         "region"   => "region_id" }
    @default_sort = 'trips.id desc'
  end

  def index
    authorize(Trip)
    @trips = Trip.joins(:track).includes(:track => [:region]).where(user_id: current_user.id)
                 .paginate(:page => params[:page]).order(order)
  end

  def new
    authorize(Trip)
    @trip = Trip.new
  end

  def create
    authorize(Trip)
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id

    if @trip.save
      redirect_to back(account_trips_url), notice: I18n.t('account.trip.was_created')
    else
      render action: "new"
    end
  end

  def edit
    authorize(@trip)
  end

  def update
    authorize(@trip)

    if @trip.update_attributes(trip_params)
      redirect_to back(account_trips_url), notice: I18n.t('account.trip.was_updated')
    else
      render action: "edit"
    end
  end

  def destroy
    authorize(@trip)

    @trip.destroy
    redirect_to request.referer || account_trips_url
  end

  def scheduled
    @default_sort = 'trips.id'
    @trips = Trip.scheduled(current_user.id)
                 .paginate(:page => params[:page]).order(order)
  end

  def archive
    @trips = Trip.archive(current_user.id)
                 .paginate(:page => params[:page]).order(order)
  end

  private

  def set_trip
    @trip = Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(policy(Trip).permitted_attributes)
  end
end
