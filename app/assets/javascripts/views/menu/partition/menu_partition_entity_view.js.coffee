#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
_.namespace "App.views"
(->
  App.views.MenuPartitionEntityView = Backbone.View.extend(
    tagName: 'div'
    className: 'entity'

    initialize: (options) ->
      @model = options.model
      @entities = App.collections.MenuDayEntityCollection
      @render()
      @bindEvents()

    render: ->
      @$el.html($(JST["templates/food/partition/day_entity"](entity: @model)))
      @$el.attr('id', "entity_#{@model.id}").addClass("entity-#{@model.get('entity_type')}")

      unless @model.isProduct()
        @$el.droppable
          greedy: true
          accept: (if @model.get("entity_type") is 1 then ".product, .dish" else ".product")
          activeClass: "ui-state-hover"
          hoverClass: "ui-state-active"
          drop: $.proxy(@onDrop, this)
      @options.renderTo.append @$el

      if @model.isProduct()
        @$el.find("button.info").tooltip
          animation: false
          html: true
          placement: "bottom"
          container: "body"

    renderEntities: (entities) ->
      _.each(entities, ((entity) ->
        entity_view = @renderEntity entity.entity
        entity_view.renderEntities entity.children if entity.children
      ), this)

    renderEntity: (entity) ->
      new App.views.MenuPartitionEntityView
        model: entity
        renderTo: @$el.find('> .body')

    bindEvents: ->

    addNewEntity: (entity) ->
      entity_view = @addEntity(entity)
      entity_view.addDishProducts() if entity.isDish()

    addEntity: (entity) ->
      @entities.add entity
      @renderEntity entity

    addDishProducts: () ->
      dish = @model.getEntityModel()
      _.each dish.dish_products(), ((dish_product) ->
        productEntity = new App.models.MenuDayEntityModel(
          entity_id: dish_product.get("product_id")
          entity_type: 3
          day_id: @model.get 'day_id'
          parent_id: @model.id
          weight: dish_product.get("weight")
        )
        @addEntity(productEntity)
      ), this

    removeEntity: (event) ->
      event.preventDefault()
      @entities.remove @model
      @$el.remove()
      false
  )
)()
