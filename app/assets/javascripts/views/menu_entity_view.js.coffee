#= require typeahead
#= require backbone-validation
#= require rivets.min
#= require rivets-backbone
#= require rivets-formatters
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
#= require models/menu_clipboard
_.namespace "App.views"
(->
  clipboard = App.models.MenuClipboard
  App.views.MenuEntityView = Backbone.View.extend(
    tagName: 'div'
    className: 'entity'
    events:
      "click button.move-up": "moveUp"
      "click button.move-down": "moveDown"

      "click button.copy-entity": "copyEntity"
      "click button.paste-entity": "pasteToEntity"
      "click button.remove-entity": "removeEntity"

    initialize: (options) ->
      @options = options
      @model = options.model
      @entities = App.collections.MenuDayEntityCollection
      @render()
      @bindEvents()

    render: ->
      @$el.html($(JST["templates/food/day_entity"](entity: @model)))
      @$el.attr('id', "entity_#{@model.id}").addClass("entity-#{@model.get('entity_type')}")

      unless @model.isProduct()
        @$el.droppable
          greedy: true
          accept: (if @model.get("entity_type") is 1 then ".product, .dish" else ".product")
          activeClass: "ui-state-hover"
          hoverClass: "ui-state-active"
          drop: $.proxy(@onDrop, this)
        @initTypeahead(@$el.find('> .header input.quick-add'))
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
      new App.views.MenuEntityView
        model: entity
        renderTo: @$el.find('> .body')

    bindEvents: ->
      if @model.isProduct()
        rivets.bind @$el.find('> .header input.weight'), entity: @model
        Backbone.Validation.bind this,
          valid: @valid
          invalid: @invalid

    valid: (view, attr) ->
      view.$el.find("> .header input[name=#{attr}]").removeClass('error').attr('title', '')
    invalid: (view, attr, error) ->
      view.$el.find("> .header input[name=#{attr}]").addClass('error').attr('title', I18n.t(error))

    getTypeaheadConf: (entity_type = 0) ->
      conf = []
      base_conf = items: 5, minLength: 3, valueKey: 'name'
      if entity_type is 0
        conf.push $.extend {}, base_conf,
          local: App.collections.MenuMealCollection.typeahead()
          header: "<div class='dropdown-header'>#{I18n.t('menu.meals')}</div>"
      if entity_type <= 1
        conf.push $.extend {}, base_conf,
          local: App.collections.MenuDishCollection.typeahead()
          header: "<div class='dropdown-header'>#{I18n.t('menu.dishes.dishes')}</div>"
      if entity_type <= 2
        conf.push $.extend {}, base_conf,
          local: App.collections.MenuProductCollection.typeahead()
          header: "<div class='dropdown-header'>#{I18n.t('menu.products.products')}</div>"
      conf

    initTypeahead: (input) ->
      input.typeahead(@getTypeaheadConf(@model.get('entity_type')))
      input.on('typeahead:selected typeahead:autocompleted', $.proxy((event, obj) ->
        @addNewEntity(new App.models.MenuDayEntityModel(
          entity_id: obj.id
          entity_type: obj.entity_type
          parent_id: @model.id
          day_id: @model.get 'day_id'
        ))
        $(event.currentTarget).val('').typeahead('setQuery', '')
        return false
      , this))

    onDrop: (event, ui) ->
      entity = new App.models.MenuDayEntityModel(
        entity_id: ui.draggable.data("id")
        entity_type: ui.draggable.data("type")
        day_id: @model.get 'day_id'
        parent_id: @model.id
      )
      @addNewEntity(entity)

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

    pasteEntities: (entities) ->
      _.each(entities, (entity)->
        entity_view = @pasteEntity entity.entity
        entity_view.pasteEntities(entity.children) if entity.children
      , this)

    pasteEntity: (entity) ->
      entity_model = new App.models.MenuDayEntityModel
        parent_id: @model.id
        entity_id: entity.entity_id
        entity_type: entity.entity_type
        day_id: @model.get 'day_id'
        weight: entity.weight
      @addEntity entity_model

    copyEntity: (event) ->
      event.preventDefault()
      @entities.sort()
      clipboard.setObj 'entity',
        entity: @model.toJSON()
        entities: @entities.tree(@model.get('day_id'), @model.id, true)
      false

    pasteToEntity: (event) ->
      event.preventDefault()
      obj = clipboard.getObj()
      return if obj.type is 'day'
      return if obj.data.entity.entity_type < @model.get('entity_type')

      if obj.data.entity.entity_type == @model.get('entity_type')
        @pasteEntities obj.data.entities
      else
        entity_view = @pasteEntity(obj.data.entity)
        entity_view.pasteEntities(obj.data.entities)
      false

    moveUp: (event) ->
      event.stopPropagation()
      return if @model.get('sort_order') is 0

      @$el.prev().insertAfter @$el
      _.find(@entities.siblings(@model), (entity) ->
        entity.get('sort_order') is @model.get('sort_order') - 1
      , this).sortOrder(+1)
      @model.sortOrder(-1)

    moveDown: (event) ->
      event.stopPropagation()
      return unless @$el.next().length

      @$el.insertAfter @$el.next()
      _.find(@entities.siblings(@model), (entity) ->
        entity.get('sort_order') is @model.get('sort_order') + 1
      , this).sortOrder(-1)
      @model.sortOrder(+1)
  )
)()
