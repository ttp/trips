module TripsHelper
  def trip_url(trip, track)
    return trip.url if !trip.url.nil? && !trip.url.empty?
    return track.url if !track.url.nil? && !track.url.empty?
    false
  end

  def date_text(date)
    date.day.to_s + ' ' + I18n.t('date.date_month_names')[date.month] + ' ' + date.year.to_s
  end

  def dates_range_text(start_date, end_date)
    start_date = Date.parse(start_date) if start_date.is_a? String
    end_date = Date.parse(end_date) if end_date.is_a? String

    start_date_text = date_text(start_date)
    start_date_items = date_text(start_date).split(' ')
    if start_date.year == end_date.year
      start_date_items.pop
      if start_date.month == end_date.month
        start_date_items.pop
      end
    end

    return start_date_items.join(' ') + ' - ' + date_text(end_date);
  end
end
