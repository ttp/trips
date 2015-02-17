module TracksHelper
  def grouped_by_region(tracks, regions)
    groups = tracks.group_by(&:region_id)
    result = []
    regions.each do |region|
      result << [region.t, groups[region.id]] if groups.key?(region.id)
    end
    result
  end
end
