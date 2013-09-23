_.namespace "App.collections"
(->
  App.collections.MenuDishCategoryCollection = new (Backbone.Collection.extend(comparator: (item) ->
    item.get "name"
  ))
)()
