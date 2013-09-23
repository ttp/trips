#= require models/menu_dish_product_model
_.namespace "App.collections"
(->
  App.collections.MenuDishProductCollection = new (Backbone.Collection.extend(model: App.models.MenuDishProductModel))
)()
