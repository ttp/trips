#= require libs/typeahead
#= require libs/bootstrap-select
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
#= require models/menu_clipboard
#= require views/menu_entity_view
_.namespace "App.views"
(->
  clipboard = App.models.MenuClipboard
  App.views.MenuDayView = Backbone.View.extend(
    tagName: 'div'
    className: 'day tab-pane'
    events:
      "click button.move-left": "moveLeft"
      "click button.move-right": "moveRight"

      "click button.copy": "copyDay"
      "click button.paste": "pasteToDay"
      "click button.remove": "removeDay"
      "focus input.quick-add": "toggleToolbar"
      "blur input.quick-add": "toggleToolbar"

    initialize: (options) ->
      @model = options.model
      @days = App.collections.MenuDayCollection
      @entities = App.collections.MenuDayEntityCollection
      @render()
      @bindEvents()


    createTabEl: ->
      @tabEl = $("<li class='.day-tab-#{@model.id}'></li>")
      $("<a>#{@model.get('num')}</a>").attr('href', "##{@id}").appendTo(@tabEl).click (e) ->
        e.preventDefault()
        $(this).tab('show')
      @tabEl

    getDayTabEl: (day) ->
      @$el.find(".day-tab-#{day.id}")

    render: ->
      @$el.html $(JST["templates/food/day"](day: @model))
      @renderEntities @entities.tree(@model.id)
      @renderSummary()
      @options.renderTo.append @$el

      @tabEl = @createTabEl()
      @options.renderTabTo.append @tabEl
      @$el.find('select.coverage').selectpicker()

    renderEntities: (entities) ->
      App.views.MenuEntityView.prototype.renderEntities.call this, entities

    renderEntity: (entity) ->
      @$el.find('.noitems').hide()
      new App.views.MenuEntityView
        model: entity
        renderTo: @$el.find('.panel-body')

    renderSummary: ->
      @$el.find('.panel-footer').html JST["templates/food/day_summary"](@model.summary())

    show: ->
      @tabEl.find('a').tab('show')

    bindEvents: ->
      @model.on "change", ->
        @tabEl.find("a").text @model.get("num")
      , this

      updateSummary = _.throttle $.proxy(@renderSummary, this), 50
      @entities.on "add remove change", (entity) ->
        updateSummary() if entity.get('day_id') is @model.id
      , this

      @$el.droppable
        drop: $.proxy(@onDrop, this)
        activeClass: "ui-state-hover"
        hoverClass: "ui-state-active"

      @initTypeahead(@$el.find('.panel-heading input.quick-add'))

      coverage = @$el.find("select.coverage")
      rivets.bind coverage, day: @model
      coverage.trigger('change')

    initTypeahead: (input) ->
      conf = App.views.MenuEntityView.prototype.getTypeaheadConf.call this
      input.typeahead(conf)
      input.on('typeahead:selected typeahead:autocompleted', $.proxy((event, obj) ->
        @addNewEntity(new App.models.MenuDayEntityModel(
          entity_id: obj.id
          entity_type: obj.entity_type
          day_id: @model.id
        ))
        $(event.currentTarget).val('').typeahead('setQuery', '')
        return false
      , this))

    toggleToolbar: (event) ->
      $(event.target).closest('.toolbar').toggleClass('focus');

    removeDay: (e) ->
      @tabEl.fadeOut 250, $.proxy(->
        num = @model.get("num")
        @days.remove @model
        @days.each (day) ->
          day.set "num", day.get("num") - 1  if day.get("num") > num

        @$el.remove()
        switchTab = if @tabEl.next().length then @tabEl.next() else @tabEl.prev()
        switchTab.find('a').tab('show')
        @tabEl.remove()
      , this)

    onDrop: (event, ui) ->
      entity = new App.models.MenuDayEntityModel(
        entity_id: ui.draggable.data("id")
        entity_type: ui.draggable.data("type")
        day_id: @model.id
      )
      @addNewEntity entity

    addEntity: (entity) ->
      App.views.MenuEntityView.prototype.addEntity.call this, entity

    addNewEntity: (entity) ->
      App.views.MenuEntityView.prototype.addNewEntity.call this, entity

    copyDay: ->
      @entities.sort()
      clipboard.setObj 'day',
        day: @model.toJSON()
        entities: @entities.tree(@model.id, 0, true)

    pasteToDay: ->
      obj = clipboard.getObj()
      if obj.type is 'day'
        @pasteEntities(obj.data.entities, 0)
      else if obj.type is 'entity'
        entity_view = @pasteEntity(obj.data.entity, 0)
        entity_view.pasteEntities(obj.data.entities)

    pasteEntities: (entities) ->
      App.views.MenuEntityView.prototype.pasteEntities.call this, entities

    pasteEntity: (entity) ->
      entity_model = new App.models.MenuDayEntityModel
        entity_id: entity.entity_id
        entity_type: entity.entity_type
        day_id: @model.id
        weight: entity.weight
      @addEntity(entity_model)

    moveLeft: (event) ->
      return if @model.get('num') is 1
      @tabEl.prev().insertAfter @tabEl
      @days.find((day) ->
        day.get('num') is @model.get('num') - 1
      , this).num(+1)
      @model.num(-1)

    moveRight: (event) ->
      return if @model.get('num') is @days.length
      @tabEl.insertAfter @tabEl.next()
      @days.find((day) ->
        day.get('num') is @model.get('num') + 1
      , this).num(-1)
      @model.num(+1)
  )
)()
