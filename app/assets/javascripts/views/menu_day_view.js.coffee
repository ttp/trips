#= require libs/typeahead
#= require libs/backbone-validation
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
      "focus input.quick-add": "toggleToolbar"
      "blur input.quick-add": "toggleToolbar"

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
      @renderSummary()
      @options.renderTo.append @$el

      @tabEl = @createTabEl()
      @options.renderTabTo.append @tabEl

    renderEntities: (entities) ->
      _.each(entities, ((entity) ->
        @renderEntity entity.entity
        @renderEntities entity.children if entity.children
      ), this)

    renderSummary: ->
      @$el.find('.panel-footer').html JST["templates/food/day_summary"](@model.summary())

    show: ->
      @tabEl.find('a').tab('show')

    bindEvents: ->
      @model.on "change", ->
        @tabEl.find("a").text @model.get("num")
      , this

      Backbone.Validation.bind this,
        valid: @valid
        invalid: @invalid

      updateSummary = _.throttle $.proxy(@renderSummary, this), 50
      @entities.on "add remove change", (entity) ->
        updateSummary() if entity.get('day_id') is @model.id
      , this

      @$el.droppable
        drop: $.proxy(@onEntityDrop, this)
        activeClass: "ui-state-hover"
        hoverClass: "ui-state-active"

      @initTypeahead(@$el.find('.panel-heading input.quick-add'))

      rivets.bind @$el.find("input.rate"),
        day: @model

    initTypeahead: (input, entity_type = 0, parent_id = 0) ->
      conf = []
      base_conf = items: 5, minLength: 3, valueKey: 'name'
      if entity_type is 0
        conf.push $.extend {}, base_conf,
          local: App.collections.MenuMealCollection.typeahead()
          header: "<div class='dropdown-header'>#{I18n.t('menu.meals')}</div>"
      if entity_type <= 1
        conf.push $.extend {}, base_conf,
          local: App.collections.MenuDishCollection.typeahead()
          header: "<div class='dropdown-header'>#{I18n.t('menu.dishes')}</div>"
      if entity_type <= 2
        conf.push $.extend {}, base_conf,
          local: App.collections.MenuProductCollection.typeahead()
          header: "<div class='dropdown-header'>#{I18n.t('menu.products')}</div>"
      input.typeahead(conf)
      input.on('typeahead:selected typeahead:autocompleted', $.proxy((event, obj) ->
        @_addEntity(new App.models.MenuDayEntityModel(
          entity_id: obj.id
          entity_type: obj.entity_type
          parent_id: parent_id
          day_id: @model.id
        ))
        $(event.currentTarget).val('').typeahead('setQuery', '')
        return false
      , this))

    valid: (view, attr) ->
      view.$el.find("input[name=#{attr}]").removeClass('error').attr('title', '')
    invalid: (view, attr, error) ->
      view.$el.find("input[name=#{attr}]").addClass('error').attr('title', error)

    toggleToolbar: (event) ->
      $(event.target).closest('.toolbar').toggleClass('focus');

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
      @_addEntity(entity)

    _addEntity: (entity) ->
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
        entityEl.appendTo @$el.find("#entity_#{entity.get('parent_id')} > .body")
      else
        entityEl.appendTo @$el.find(".panel-body")

      if entity.isProduct()
        rivets.bind entityEl, entity: entity
      else
        entityEl.droppable
          greedy: true
          accept: (if entity.get("entity_type") is 1 then ".product, .dish" else ".product")
          activeClass: "ui-state-hover"
          hoverClass: "ui-state-active"
          drop: $.proxy(@onEntityDrop, this)
        @initTypeahead(entityEl.find('> .header input.quick-add'), entity.get('entity_type'), entity.id)
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
