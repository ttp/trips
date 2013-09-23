#= require collections/menu_meal_collection
#= require collections/menu_dish_collection
#= require collections/menu_product_collection

(->
  _.namespace "App.models"
  App.models.MenuDayEntityModel = Backbone.Model.extend(
    defaults:
      parent_id: 0
      weight: 0

    validation:
      weight: [
        required: true
        msg: 'menu.validation.enter_weight'
      ,
        min: 0
        msg: "menu.validation.incorrect"
      ]

    initialize: ->
      unless @id
        @set "id", @cid
        @set "new", 1
      @set "parent_id", 0  if _.isNull(@get("parent_id"))

    getName: ->
      @getEntityModel().get "name"

    getEntityModel: ->
      @getEntityCollection().get @get("entity_id")

    getEntityCollection: ->
      switch @get("entity_type")
        when 1
          App.collections.MenuMealCollection
        when 2
          App.collections.MenuDishCollection
        when 3
          App.collections.MenuProductCollection

    isProduct: ->
      @get("entity_type") is 3

    isDish: ->
      @get("entity_type") is 2
  )
)()
