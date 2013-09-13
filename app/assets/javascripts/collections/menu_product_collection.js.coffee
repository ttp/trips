_.namespace "App.collections"
(->
  App.collections.MenuProductCollection = new (Backbone.Collection.extend(comparator: (item) ->
    item.get "name"
  ))
)()
