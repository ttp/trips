module TracksHelper
  def grouped_by_region(tracks, regions)
    groups = tracks.group_by {|row| row.region_id}
    result = []
    regions.each do |region|
      result << [region.t, groups[region.id]] if groups.has_key?(region.id)
    end
    return result
  end
end
