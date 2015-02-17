class Account::TracksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_track, only: [:edit, :update, :destroy]

  def initialize
    super
    @sortable_fields = { 'id'     => 'id',
                         'region' => 'region_id',
                         'name'   => 'name' }
    @default_sort = 'id desc'
  end

  def index
    authorize(Track)

    @tracks = Track.where(user_id: current_user.id).includes(:region)
              .order(order).paginate(page: params[:page])
  end

  def new
    authorize(Track)
    @track = Track.new
  end

  def create
    authorize(Track)
    @track = Track.new(track_params)
    @track.user_id = current_user.id

    if @track.save
      redirect_to back(account_tracks_url), notice: I18n.t('account.track.was_created')
    else
      render action: 'new'
    end
  end

  def edit
    authorize(@track)
  end

  def update
    authorize(@track)

    if @track.update_attributes(track_params)
      redirect_to back(account_tracks_url), notice: I18n.t('account.track.was_updated')
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize(@track)

    @track.destroy

    redirect_to request.referer || account_tracks_url
  end

  private

  def set_track
    @track = Track.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to account_tracks_path, alert: t('errors.messages.not_found')
  end

  def track_params
    params.require(:track).permit(policy(Track).permitted_attributes)
  end
end
