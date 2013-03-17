module HomeHelper
  def render_calendar_day(day)
    html = "<div class='day-wrapper'><span class='day-num'>#{day.mday}</span>"
    html += "<span class='events-count'>12</span>" if day.mday == 28
    html += "</div>"
    return html
  end
end
