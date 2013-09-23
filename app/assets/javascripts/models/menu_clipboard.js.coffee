(->
  _.namespace "App.models"

  App.models.MenuClipboard = new (Backbone.Model.extend(
    setObj: (type, data)->
      @set 'type', type
      @set 'data', data

    getObj: ->
      type: @get 'type'
      data: @get 'data'

    clean: ->
      @set 'type', null
      @set 'data', null

    isEmpty: ->
      @get 'data' is null
  ))
)()