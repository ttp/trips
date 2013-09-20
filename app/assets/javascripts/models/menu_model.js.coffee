_.namespace "App.models"
(->
  App.models.MenuModel = Backbone.Model.extend(
    validation:
      name:
        required: true
        msg: 'Please enter an menu name'
      users_count: [
        required: true
        msg: 'Please enter persons count'
      ,
        min: 1
        msg: "You should have at least one person"
      ]

    initialize: ->
      @set "days_count", parseFloat(@get("days_count"))
  )
)()
