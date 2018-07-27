class Map::MarkersController < ApplicationController
  def new
    @map_marker = Map::Marker.new
  end

  def create
    @map_marker = Map::Marker.new(marker_params)
    if @map_marker.save
      redirect_to back(map_marker_path(@map_marker)), notice: 'Created'
    end
  end

  private

  def marker_params
    params.require(:trip).permit(policy(Trip).permitted_attributes)
  end
end
