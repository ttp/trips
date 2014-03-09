#= require collections/trip_collection
#= require models/filters
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
      @_initSelected()

    initSlider: ->
      filter = @_trips.getFilter('cached_duration')
      options = @_getDurationOptions()
      input = @$el.find('input.duration')
      input.slider(
        min: options.min
        max: options.max
        value: if filter then filter.values else [options.min, options.max]
      )
      self = this
      input.on 'slideStop', ->
        _.defer ->
          values = _.map(input.val().split(','), (value) -> parseInt(value))
          self._trips.setFilter('cached_duration', new App.FilterRange(values))
          self.render()

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

    _getDurationOptions: ->
      min = 100
      max = 1
      @_trips.each (row) ->
        min = Math.min(min, row.get('cached_duration'))
        max = Math.max(max, row.get('cached_duration'))
      {min: min, max: max}

    _initSelected: ->
      _.each @_trips.getFilters(), ((filter, field) ->
        inputs = $("input[name=\"" + field + "\"]")
        _.each filter.values, ((value) ->
          inputs.filter("[value=\"" + value + "\"]").attr "checked", true
        ), this
      ), this
      @initSlider()

    updateFilter: (e) ->
      input = $(e.target)
      if input.is(":checked")
        @_trips.addFilterValue input.attr("name"), input.val()
      else
        @_trips.removeFilterValue input.attr("name"), input.val()
      @render()
  )
)()
