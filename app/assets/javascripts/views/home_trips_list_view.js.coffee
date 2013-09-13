#= require collections/trip_collection
_.namespace "App.views"
(->
  App.views.HomeTripsListView = Backbone.View.extend(
    el: "#trips"
    events:
      "click button.close": "hide"

    initialize: (options) ->
      @options = options
      @_trips = App.collections.TripCollection
      @_trips.on "filter:day", @render, this

    hide: ->
      @$el.hide()

    render: (day) ->
      if day is null
        @$el.find(".trips-body").html ""
        return
      data = trips: @_trips.filtered(start_date: day)
      @$el.find(".trips-body").html JST["templates/home/trips_list"](data)
      @bindEvents()

    bindEvents: ->
      trips = @_trips
      @$el.find(".icon-eye-open").mouseenter(->
        trips.trigger "trip:hover", $(this).closest(".trip").data("trip-id")
      ).mouseleave ->
        trips.trigger "trip:out", $(this).closest(".trip").data("trip-id")

  )
)()
