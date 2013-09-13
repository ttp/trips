#= require collections/menu_dish_product_collection
_.namespace "App.models"
(->
  App.models.MenuDishModel = Backbone.Model.extend(
    dish_products: ->
      App.collections.MenuDishProductCollection.where dish_id: @id

    products_titles: ->
      _.map @dish_products(), (dish_product) ->
        dish_product.title()

  )
)()
