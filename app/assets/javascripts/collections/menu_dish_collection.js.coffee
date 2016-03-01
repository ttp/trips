#= require models/menu_dish_model
_.namespace "App.collections"
(->
  App.collections.MenuDishCollection = new (Backbone.Collection.extend
    model: App.models.MenuDishModel
    url: '/api/v1/menu/dishes'

    comparator: (item) -> item.get "name"

    typeahead: ->
      @typeahead_list ||= @map (item) -> id: item.id, name: item.get('name'), entity_type: 2
  )
)()
