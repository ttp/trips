#= require models/menu_dish_model
_.namespace "App.collections"
(->
  App.collections.MenuDishCollection = new (Backbone.Collection.extend(
    model: App.models.MenuDishModel
    comparator: (item) ->
      item.get "name"
  ))
)()
