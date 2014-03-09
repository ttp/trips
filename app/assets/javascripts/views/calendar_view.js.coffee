#= require calendar
#= require date
#= require collections/trip_collection
_.namespace "App.views"
(->
  App.views.CalendarView = Backbone.View.extend(
    el: "#calendar"
    initialize: (options) ->
      @_calendar = new Calendar(
        cal_days_labels: I18n.t("date.abbr_day_names")
        cal_months_labels: I18n.t("date.month_names")
      )
      @options = options
      @_start_date = options.start_date
      @_trips = App.collections.TripCollection
      @bindEvents()
      @render()
      @_trips.fetch()

    bindEvents: ->
      @_trips.on "reset", @showCalendarTrips, this
      @_trips.on "filter:changed", @showCalendarTrips, this
      @_trips.on "trip:hover", @highlightTrip, this
      @_trips.on "trip:out", @cleanHighlight, this
      @$el.delegate "td.start-day", "click", $.proxy(@onDayClick, this)
      $("#trips button.close").click $.proxy(@deselectDay, this)
      $("a.prev").click $.proxy(@scrollToPrevMonths, this)
      $("a.next").click $.proxy(@scrollToNextMonths, this)

    scrollToPrevMonths: (e) ->
      return  if $(":animated").length
      rows = @_visibleRows()
      prev = rows.first().prev()
      return  unless prev.length
      height = rows.first().height()
      prev.css("margin-top", -height + "px").show()
      prev.animate
        "margin-top": "0px"
      , 500
      rows.last().slideUp 500
      $(":animated").promise().done $.proxy(->
        @refreshNavigation()
      , this)

    scrollToNextMonths: (e) ->
      return  if $(":animated").length
      rows = @_visibleRows()
      next = rows.last().next()
      return  unless next.length
      height = rows.first().height()
      rows.first().animate
        "margin-top": -height + "px"
      , 500
      rows.last().next().slideDown 500
      $(":animated").promise().done $.proxy(->
        rows.first().hide()
        @refreshNavigation()
      , this)

    refreshNavigation: ->
      rows = @_visibleRows()
      $("a.prev").toggleClass "disabled", not rows.first().prev().length
      $("a.next").toggleClass "disabled", not rows.last().next().length

    _visibleRows: ->
      @$el.find ".row:visible"

    onDayClick: (e) ->
      e.preventDefault()
      dayEl = $(e.currentTarget)
      if @_daySelected(dayEl)
        @deselectDay dayEl
      else
        @selectDay dayEl

    deselectDay: ->
      @cleanTracks()
      @_startDate = null
      @showFilters()
      @_trips.trigger "filter:day", @_startDate

    selectDay: (dayEl) ->
      @cleanTracks()
      dayEl.addClass "selected"
      @_startDate = dayEl.attr("id").replace("day-", "")
      dayTrips = @_trips.filtered(start_date: @_startDate)
      tripsByEndDate = _.groupBy(dayTrips, (trip) ->
        trip.get "end_date"
      )
      _.each _.keys(tripsByEndDate), ((end_date) ->
        endDayNumEl = $("<span></span>").addClass("end-day-num").text(tripsByEndDate[end_date].length)
        $("#day-" + end_date).addClass("end-day").find(".day-wrapper").append endDayNumEl
        @drawTripTrack @_startDate, end_date
      ), this
      @_trips.trigger "filter:day", @_startDate
      @showTrips()

    drawTripTrack: (start_day, end_day) ->
      days = @_getDays(new Date(start_day), new Date(end_day))
      _.each days, (day) ->
        $("#day-" + day.toString("yyyy-MM-dd")).addClass "track"


    cleanTracks: ->
      @$el.find(".end-day-num").remove()
      @$el.find(".track, .end-day, .selected").removeClass "track end-day selected"

    _daySelected: (dayEl) ->
      dayEl.hasClass "selected"

    showFilters: ->
      $("#trips").hide()
      $("#filters").show()

    showTrips: ->
      $("#trips").show()
      $("#filters").hide()

    highlightTrip: (trip_id) ->
      if trip_id
        trip = @_trips.get(trip_id)
        @highlightDays trip.get("start_date"), trip.get("end_date")
      else
        @cleanHighlight()

    cleanHighlight: ->
      @$el.find(".highlight").removeClass "highlight"

    highlightDays: (startDay, endDay) ->
      days = @_getDays(new Date(startDay), new Date(endDay))
      _.each days, (day) ->
        $("#day-" + day.toString("yyyy-MM-dd")).addClass "highlight"


    _getDays: (startDate, endDate) ->
      retVal = []
      current = new Date(startDate)
      while current <= endDate
        retVal.push new Date(current)
        current = current.next().day()
      retVal

    showCalendarTrips: ->
      @$el.find(".events-count").remove()
      @$el.find(".start-day").removeClass "start-day"
      filtered = @_trips.filtered()
      $("#trips_qty").text " - " + filtered.length
      grouped = _.groupBy(filtered, (row) ->
        row.get "start_date"
      )
      _.each grouped, ((trips, day) ->
        daysCount = $("<span></span>").addClass("events-count").text(trips.length)
        @$el.find("#day-" + day).addClass("start-day").find(".day-wrapper").append daysCount
      ), this

    render: ->
      data =
        calendar: @_calendar
        class_name: ""

      html = ""
      date = @_start_date.clone()
      row = undefined
      i = 0

      while i < 6
        data.class_name = "x-hidden"  if i is 2
        data.dates = [date, date.clone().addMonths(1)]
        html += JST["templates/home/calendar_row"](data)
        date = date.add(2).month()
        i++
      @$el.html html
      @refreshNavigation()
  )
)()
