#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
_.namespace "App.views"
(->
  App.views.MenuDayView = Backbone.View.extend(
    events:
      "click button.close": "removeDay"
      "click .glyphicon-remove": "removeEntity"

    initialize: (options) ->
      @model = options.model
      @entities = App.collections.MenuDayEntityCollection
      @render()
      @bindEvents()

    render: ->
      @$el.addClass "day"
      @$el.html $(JST["templates/food/day"](day: @model))
      @$el.droppable
        drop: $.proxy(@onEntityDrop, this)
        activeClass: "ui-state-hover"
        hoverClass: "ui-state-active"

      rivets.bind @$el.find("input.rate"),
        day: @model

      entities = _.groupBy(@entities.where(day_id: @model.id), (item) ->
        item.get("parent_id") or 0
      )
      @renderEntities entities, 0

    renderEntities: (entities, parent_id) ->
      return  unless entities[parent_id]
      _.each entities[parent_id], ((entity) ->
        @renderEntity entity
        @renderEntities entities, entity.id
      ), this

    bindEvents: ->
      @model.on "change", $.proxy(->
        @$el.find(".num").text @model.get("num")
      , this)

    removeDay: (e) ->
      num = @model.get("num")
      App.collections.MenuDayCollection.remove @model
      App.collections.MenuDayCollection.each (day) ->
        day.set "num", day.get("num") - 1  if day.get("num") > num

      @$el.remove()

    onEntityDrop: (event, ui) ->
      $this = $(event.target)
      entity = new App.models.MenuDayEntityModel(
        entity_id: ui.draggable.data("id")
        entity_type: ui.draggable.data("type")
        day_id: @model.id
      )
      if $this.is(".entity")
        parent_id = $this.attr("id").split("_")[1]
        entity.set "parent_id", parent_id
      @entities.add entity
      @renderEntity entity
      @renderDishProducts entity  if entity.isDish()

    renderDishProducts: (entity) ->
      dish = entity.getEntityModel()
      _.each dish.dish_products(), ((dish_product) ->
        productEntity = new App.models.MenuDayEntityModel(
          entity_id: dish_product.get("product_id")
          entity_type: 3
          day_id: @model.id
          parent_id: entity.id
          weight: dish_product.get("weight")
        )
        @entities.add productEntity
        @renderEntity productEntity
      ), this

    renderEntity: (entity) ->
      @$el.find(".noitems").hide()
      entityEl = $(JST["templates/food/day_entity"](entity: entity))
      if entity.get("parent_id")
        entityEl.appendTo @$el.find("#entity_" + entity.get("parent_id"))
      else
        entityEl.appendTo @$el.find(".body")
      unless entity.isProduct()
        entityEl.droppable
          greedy: true
          accept: (if entity.get("entity_type") is 1 then ".product, .dish" else ".product")
          activeClass: "ui-state-hover"
          hoverClass: "ui-state-active"
          drop: $.proxy(@onEntityDrop, this)

      else
        rivets.bind entityEl,
          entity: entity

      entityEl

    removeEntity: (event) ->
      entityEl = $(event.target).closest(".entity")
      id = entityEl.attr("id").split("_")[1]
      entity = @entities.get(id)
      @entities.remove entity
      entityEl.remove()
  )
)()
