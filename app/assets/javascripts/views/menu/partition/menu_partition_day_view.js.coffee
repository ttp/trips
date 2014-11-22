#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/menu_day_entity_model
#= require models/menu_clipboard
#= require views/menu/partition/menu_partition_entity_view
#= require views/menu/partition/menu_partition_split_popup_view
_.namespace "App.views"
(->
  clipboard = App.models.MenuClipboard
  App.views.MenuPartitionDayView = Backbone.View.extend(
    tagName: 'div'
    className: 'day tab-pane'
    events:
      "click button.auto-split": "autoSplit"

    initialize: (options) ->
      @options = options
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
      @tabEl.data('day_id', @model.get('id'))
      @tabEl

    getDayTabEl: (day) ->
      @$el.find(".day-tab-#{day.id}")

    render: ->
      @$el.html $(JST["templates/food/partition/day"](day: @model))
      @renderEntities @entities.tree(@model.id)
      @renderSummary()
      @options.renderTo.append @$el

      @tabEl = @createTabEl()
      @options.renderTabTo.append @tabEl

    renderEntities: (entities) ->
      App.views.MenuPartitionEntityView.prototype.renderEntities.call this, entities

    renderEntity: (entity) ->
      @$el.find('.noitems').hide()
      new App.views.MenuPartitionEntityView
        model: entity
        renderTo: @$el.find('.panel-body')

    renderSummary: ->
      @$el.find('.panel-footer').html JST["templates/food/partition/day_summary"](@model.summary())

    show: ->
      @tabEl.find('a').tab('show')

    bindEvents: ->
      updateSummary = _.throttle $.proxy(@renderSummary, this), 50
      @entities.on "add remove change", (entity) ->
        updateSummary() if entity.get('day_id') is @model.id
      , this

    splitPopup: ->
      @splitPopupView ?= new App.views.MenuPartitionSplitPopupView

    autoSplit: (e) ->
      e.preventDefault()
      @splitPopup().render()
      @splitPopup().show()
  )
)()