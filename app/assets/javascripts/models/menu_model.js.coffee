_.namespace "App.models"
(->
  App.models.MenuModel = Backbone.Model.extend(initialize: ->
    @set "days_count", parseFloat(@get("days_count"))
  )
)()
