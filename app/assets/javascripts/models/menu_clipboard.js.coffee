(->
  _.namespace "App.models"

  App.models.MenuClipboard = new (Backbone.Model.extend(
    setObj: (type, obj)->
      @set 'type', type
      @set 'obj', obj

    getObj: ->
      type: @get 'type'
      obj: @get 'obj'

    clean: ->
      @set 'type', null
      @set 'obj', null

    isEmpty: ->
      @get 'obj' is null
  ))
)()