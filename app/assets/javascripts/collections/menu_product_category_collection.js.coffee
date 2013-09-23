_.namespace "App.collections"
(->
  App.collections.MenuProductCategoryCollection = new (Backbone.Collection.extend(comparator: (item) ->
    item.get "name"
  ))
)()
