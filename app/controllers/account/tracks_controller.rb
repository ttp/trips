class Account::TracksController < ApplicationController
  before_filter :authenticate_user!

  def initialize
    super
    @sortable_fields = {
        "id"     => "id",
        "region" => "region_id",
        "name"   => "name"
    }
    @default_sort = 'id desc'
  end

  # GET /tracks
  # GET /tracks.json
  def index
    logger.info(order)
    @tracks = Track.includes(:region).where("user_id = ?", current_user.id)
                   .paginate(:page => params[:page], :per_page => 10, :order => order)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tracks }
    end
  end

  # GET /tracks/1
  # GET /tracks/1.json
  def show
    @track = Track.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/new
  # GET /tracks/new.json
  def new
    @track = Track.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @track }
    end
  end

  # GET /tracks/1/edit
  def edit
    @track = Track.find(params[:id])
    redirect_to account_tracks_url if @track.user_id != current_user.id
  end

  # POST /tracks
  # POST /tracks.json
  def create
    @track = Track.new(params[:track])
    @track.user_id = current_user.id

    respond_to do |format|
      if @track.save
        format.html { redirect_to back(account_tracks_url), notice: I18n.t('account.track.was_created') }
        format.json { render json: @track, status: :created, location: @track }
      else
        format.html { render action: "new" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tracks/1
  # PUT /tracks/1.json
  def update
    @track = Track.find(params[:id])
    redirect_to back(account_tracks_url) if @track.user_id != current_user.id

    respond_to do |format|
      if @track.update_attributes(params[:track])
        format.html { redirect_to back(account_tracks_url), notice: I18n.t('account.track.was_updated') }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @track.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tracks/1
  # DELETE /tracks/1.json
  def destroy
    @track = Track.find(params[:id])
    redirect_to request.referer || account_tracks_url if @track.user_id != current_user.id

    @track.destroy

    respond_to do |format|
      format.html { redirect_to request.referer || account_tracks_url }
      format.json { head :no_content }
    end
  end
end
