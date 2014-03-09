_.namespace "App"

class App.Filter
  constructor: (values) ->
    @values = values || []

class App.FilterInclude extends App.Filter
  add: (value) ->
    @values.push value

  remove: (value) ->
    @values = _.without(@values, value)

  match: (value) ->
    _.contains(@values, value)

class App.FilterRange extends App.Filter
  match: (value) ->
    @values[0] <= parseInt(value) && parseInt(value) <= @values[1]