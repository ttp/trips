#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
#=require models/menu_clipboard
_.namespace "App.views"
(->
  App.views.MenuDayView = Backbone.View.extend(
    tagName: 'div'
    className: 'day tab-pane'
    events:
      "click button.copy": "copyDay"
      "click button.remove": "removeDay"

      "click button.copy-entity": "copyEntity"
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
      entities = _.groupBy(@entities.where(day_id: @model.id), (item) ->
        item.get("parent_id") or 0
      )
      @renderEntities entities, 0
      @options.renderTo.append @$el

      @tabEl = @createTabEl()
      @options.renderTabTo.append @tabEl

    renderEntities: (entities, parent_id) ->
      return  unless entities[parent_id]
      _.each entities[parent_id], ((entity) ->
        @renderEntity entity
        @renderEntities entities, entity.id
      ), this

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

    removeEntity: (event) ->
      entityEl = $(event.target).closest(".entity")
      id = entityEl.attr("id").split("_")[1]
      entity = @entities.get(id)
      @entities.remove entity
      entityEl.remove()

    copyDay: ->
      App.modles.MenuClipboard.setObj 'day', this.model.toJSON()

    copyEntity: (event) ->
      entityEl = $(event.target).closest(".entity")
      id = entityEl.attr("id").split("_")[1]
      entity = @entities.get(id)
      App.models.MenuClipboard.setObj 'entity', entity.toJSON()
  )
)()
