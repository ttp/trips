#= require collections/menu_product_collection
_.namespace "App.models"
(->
  App.models.MenuDishProductModel = Backbone.Model.extend(
    product: ->
      App.collections.MenuProductCollection.get @get("product_id")

    title: ->
      @product().get("name") + ": " + @get("weight")
  )
)()
