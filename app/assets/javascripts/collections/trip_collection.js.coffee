#= require models/trip_model
#= require models/filters

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

    getFilter: (field) ->
      @_filters[field]

    setFilter: (field, filter) ->
      @_filters[field] = filter
      @trigger "filter:changed"

    addFilterValue: (field, value) ->
      if _.isUndefined(@_filters[field])
        @setFilter(field, new App.FilterInclude([value]))
      else
        @_filters[field].add value
      @_cleanHiddenFilters()
      @trigger "filter:changed"

    _cleanHiddenFilters: ->
      grouped = undefined
      _.each @_filters, ((filter, field) ->
        return if filter.constructor != App.FilterInclude
        grouped = _.groupBy(@filtered(false, field), (row) ->
          row.get field
        )
        hiddenValues = _.difference(filter.values, _.keys(grouped))
        _.each hiddenValues, ((hiddenValue) ->
          @removeFilterValue field, hiddenValue
        ), this
      ), this

    removeFilterValue: (field, value) ->
      @_filters[field].remove value
      delete @_filters[field]  unless @_filters[field].values.length
      @_cleanHiddenFilters()
      @trigger "filter:changed"

    filtered: (filters, skip) ->
      if filters
        filters = _.extend(filters, @_filters)
      else
        filters = @_filters
      return @toArray()  unless _.size(filters)
      @filter ((item) ->
        match = true
        for field of filters
          continue  if skip and field is skip
          match = match and filters[field].match(item.get(field) + "")
        match
      ), this

    upcoming: ->
      yesterday = new Date().addDays(-1)
      @filter (item) ->
        yesterday.isBefore new Date(item.get("start_date"))

  ))
)()
