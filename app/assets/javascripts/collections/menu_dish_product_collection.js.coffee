#= require models/menu_dish_product_model
_.namespace "App.collections"
(->
  App.collections.MenuDishProductCollection = new (Backbone.Collection.extend(
    model: App.models.MenuDishProductModel
    url: '/api/v1/menu/dishes/all_dish_products'
  ))
)()
