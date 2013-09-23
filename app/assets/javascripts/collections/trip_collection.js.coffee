#= require models/trip_model
_.namespace "App.collections"
(->
  App.collections.TripCollection = new (Backbone.Collection.extend(
    model: App.models.TripModel
    url: "/trips"
    _filters: {}
    comparator: (item) ->
      item.get("start_date") + " " + item.get("end_date")

    getFilters: ->
      @_filters

    setFilter: (type, value) ->
      @_filters[type] = []  if _.isUndefined(@_filters[type])
      @_filters[type] = [value]
      @trigger "filter:changed"

    addFilter: (type, value) ->
      @_filters[type] = []  if _.isUndefined(@_filters[type])
      @_filters[type].push value
      @_cleanHiddenFilters()
      @trigger "filter:changed"

    _cleanHiddenFilters: ->
      grouped = undefined
      _.each @_filters, ((values, type) ->
        grouped = _.groupBy(@filtered(false, type), (row) ->
          row.get type
        )
        hiddenValues = _.difference(values, _.keys(grouped))
        _.each hiddenValues, ((hiddenValue) ->
          @removeFilter type, hiddenValue
        ), this
      ), this

    removeFilter: (type, value) ->
      @_filters[type] = _.without(@_filters[type], value)
      delete @_filters[type]  unless @_filters[type].length
      @trigger "filter:changed"

    filtered: (filters, skip) ->
      if filters
        filters = _.extend(filters, @_filters)
      else
        filters = @_filters
      return @toArray()  unless _.size(filters)
      @filter ((item) ->
        match = true
        for type of filters
          continue  if skip and type is skip
          match = match and ((if _.isArray(filters[type]) then _.contains(filters[type], item.get(type) + "") else item.get(type) is filters[type]))
        match
      ), this

    upcoming: ->
      yesterday = new Date().addDays(-1)
      @filter (item) ->
        yesterday.isBefore new Date(item.get("start_date"))

  ))
)()
