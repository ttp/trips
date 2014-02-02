#= require collections/trip_collection
_.namespace "App.views"
(->
  App.views.HomeFiltersView = Backbone.View.extend(
    el: "#filters"
    events:
      "change input": "updateFilter"

    filterSorters:
      region_name: (item) ->
        I18n.t "region." + item[0]

      has_guide: (item) ->
        I18n.t "trip.has_guide_" + item[0]

      user_name: (item) ->
        item[0]

    initialize: (options) ->
      @options = options
      @_trips = App.collections.TripCollection
      @_trips.on "reset", @render, this

    render: ->
      data = @_getFilterOptions()
      @$el.html JST["templates/home/filters"](data)
      @_checkSelected()

    _getFilterOptions: ->
      options = {}
      _.each _.keys(@filterSorters), ((type) ->
        key = "trips_by_" + type
        options[key] = _.chain(@_trips.filtered(false, type)).groupBy((row) ->
          row.get type
        ).map((items, key) ->
          [key, items.length]
        ).sortBy(@filterSorters[type]).value()
      ), this
      options

    _checkSelected: ->
      _.each @_trips.getFilters(), ((values, filter) ->
        inputs = $("input[name=\"" + filter + "\"]")
        _.each values, ((value) ->
          inputs.filter("[value=\"" + value + "\"]").attr "checked", true
        ), this
      ), this

    updateFilter: (e) ->
      input = $(e.target)
      if input.is(":checked")
        @_trips.addFilter input.attr("name"), input.val()
      else
        @_trips.removeFilter input.attr("name"), input.val()
      @render()
  )
)()
