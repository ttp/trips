#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
#= require models/menu_clipboard
_.namespace "App.views"
(->
  clipboard = App.models.MenuClipboard
  App.views.MenuDayView = Backbone.View.extend(
    tagName: 'div'
    className: 'day tab-pane'
    events:
      "click button.copy": "copyDay"
      "click button.paste": "pasteToDay"
      "click button.remove": "removeDay"
      "click button.copy-entity": "copyEntity"
      "click button.paste-entity": "pasteToEntity"
      "click button.remove-entity": "removeEntity"

    initialize: (options) ->
      @model = options.model
      @entities = App.collections.MenuDayEntityCollection
      @render()
      @bindEvents()


    createTabEl: ->
      tabEl = $("<li class='.day-tab-#{@model.id}'></li>")
      $("<a>#{@model.get('num')}</a>").attr('href', "##{@id}").appendTo(tabEl).click (e) ->
        e.preventDefault()
        $(this).tab('show')
      tabEl

    getDayTabEl: (day) ->
      @$el.find(".day-tab-#{day.id}")

    render: ->
      @$el.html $(JST["templates/food/day"](day: @model))
      @renderEntities @entities.tree(@model.id)
      @options.renderTo.append @$el

      @tabEl = @createTabEl()
      @options.renderTabTo.append @tabEl

    renderEntities: (entities) ->
      _.each(entities, ((entity) ->
        @renderEntity entity.entity
        @renderEntities entity.children if entity.children
      ), this)

    show: ->
      @tabEl.find('a').tab('show')

    bindEvents: ->
      @model.on "change", ->
        @tabEl.find("a").text @model.get("num")
      , this

      @$el.droppable
        drop: $.proxy(@onEntityDrop, this)
        activeClass: "ui-state-hover"
        hoverClass: "ui-state-active"

      rivets.bind @$el.find("input.rate"),
        day: @model

    removeDay: (e) ->
      @tabEl.fadeOut 250, $.proxy(->
        num = @model.get("num")
        App.collections.MenuDayCollection.remove @model
        App.collections.MenuDayCollection.each (day) ->
          day.set "num", day.get("num") - 1  if day.get("num") > num

        @$el.remove()
        switchTab = if @tabEl.next().length then @tabEl.next() else @tabEl.prev()
        switchTab.find('a').tab('show')
        @tabEl.remove()
      , this)

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

    _getEntityElByEvent: (event) ->
      $(event.target).closest(".entity")

    _getEntityByEvent: (event) ->
      entityEl = @_getEntityElByEvent(event)
      id = entityEl.attr("id").split("_")[1]
      @entities.get(id)

    removeEntity: (event) ->
      entity = @_getEntityByEvent event
      @entities.remove entity
      @_getEntityElByEvent(event).remove()

    copyDay: ->
      clipboard.setObj 'day',
        day: @model.toJSON()
        entities: @entities.tree(@model.id, 0, true)

    pasteToDay: ->
      obj = clipboard.getObj()
      if obj.type is 'day'
        @_pasteEntities(obj.data.entities, 0)
      else if obj.type is 'entity'
        entity = @_pasteEntity(obj.data.entity, 0)
        @_pasteEntities(obj.data.entities, entity.id)

    _pasteEntities: (entities, parent_id) ->
      _.each(entities, (entity)->
        entity_model = @_pasteEntity entity.entity, parent_id
        @_pasteEntities(entity.children, entity_model.id) if entity.children
      , this)

    _pasteEntity: (entity, parent_id) ->
      entity_model = new App.models.MenuDayEntityModel
        parent_id: parent_id
        entity_id: entity.entity_id
        entity_type: entity.entity_type
        day_id: @model.id
        weight: entity.weight
      @entities.add entity_model
      @renderEntity entity_model
      entity_model

    copyEntity: (event) ->
      entity = @_getEntityByEvent event
      clipboard.setObj 'entity',
        entity: entity.toJSON()
        entities: @entities.tree(@model.id, entity.id, true)

    pasteToEntity: (event) ->
      obj = clipboard.getObj()
      return if obj.type is 'day'

      entity = @_getEntityByEvent event
      return if obj.data.entity.entity_type < entity.get('entity_type')

      if obj.data.entity.entity_type == entity.get('entity_type')
        @_pasteEntities obj.data.entities, entity.id
      else
        new_entity = @_pasteEntity(obj.data.entity, entity.id)
        @_pasteEntities(obj.data.entities, new_entity.id)
  )
)()
