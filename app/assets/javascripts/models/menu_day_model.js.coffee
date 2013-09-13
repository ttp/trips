_.namespace "App.models"
(->
  App.models.MenuDayModel = Backbone.Model.extend(
    defaults:
      rate: 1

    initialize: ->
      unless @id
        @set "id", @cid
        @set "new", 1
      @set "rate", parseFloat(@get("rate"))
  )
)()
