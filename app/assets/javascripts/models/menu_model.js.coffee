_.namespace "App.models"
(->
  App.models.MenuModel = Backbone.Model.extend(
    validation:
      name:
        required: true
        msg: 'menu.validation.required'
      users_count: [
        required: true
        msg: 'menu.validation.required'
      ,
        min: 1
        msg: "menu.validation.incorrect"
      ]

    initialize: ->
      @set "days_count", parseFloat(@get("days_count"))
  )
)()
