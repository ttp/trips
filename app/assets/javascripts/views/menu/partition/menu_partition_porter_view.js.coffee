#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection
#= require collections/menu_day_collection
# TODO remove porter, rename porter, css
_.namespace "App.views"
(->
  days = App.collections.MenuDayCollection
  App.views.MenuPartitionPorterView = Backbone.View.extend(
    tagName: 'div'
    className: 'porter panel panel-default'
    events:
      'click .glyphicon-remove': 'remove'

    initialize: (options) ->
      @options = options
      @model = options.model
      @days_tabs = options.days_tabs
      @porters = App.collections.MenuPartitionPorterCollection
      @porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
      @render()
      @bindEvents()

    render: ->
      @$el.html JST["templates/food/partition/porter"](porter: @model, day: @currentDay())
      @renderProducts()
      @options.renderTo.append @$el

    renderProducts: ->
      html = JST["templates/food/partition/porter_products"](products: @model.products_totals(@currentDay()))
      @$el.find('.panel-body').html html

    bindEvents: ->
      @model.on('change:position', @updateName, this)
      @model.on('remove', $.proxy(@onModelRemove, this))
      @days_tabs.on 'click', $.proxy(@renderData, this)
      @porter_entities.on 'add', $.proxy(@renderData, this)
      @porter_entities.on 'remove', $.proxy(@renderData, this)
      @porters.on 'add remove', $.proxy(@renderData, this)

    currentDay: ->
      day_id = @days_tabs.find('li.active').data('day_id')
      days.get(day_id)

    remove: ->
      @porters.remove @model

    onModelRemove: -> @$el.remove()

    renderData: ->
      @renderTotals()
      @renderProducts()

    renderTotals: () ->
      day = @currentDay()
      @$el.find('.today_total').text(@model.today_weight(day))
      @$el.find('.total').text(@model.total_weight())

    updateName: ->
      @$el.find('.name').text(@model.name())
  )
)()