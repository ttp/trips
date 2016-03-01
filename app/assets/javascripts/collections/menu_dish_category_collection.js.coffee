_.namespace "App.collections"
(->
  App.collections.MenuDishCategoryCollection = new (Backbone.Collection.extend(
    comparator: (item) -> item.get "name"
    url: '/api/v1/menu/dishes/categories'
  ))
)()
