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

    initialize: (options) ->
      @options = options
      @model = options.model
      @days_tabs = options.days_tabs
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
      @model.on('remove', $.proxy(@onRemove, this))
      @days_tabs.on 'click', $.proxy(@onDayChange, this)
      @porter_entities.on 'add', $.proxy(@onPorterEntitiesUpdate, this)
      @porter_entities.on 'remove', $.proxy(@onPorterEntitiesUpdate, this)

    currentDay: ->
      day_id = @days_tabs.find('li.active').data('day_id')
      days.get(day_id)

    onDayChange: ->
      @updateTotals()
      @renderProducts()

    onRemove: -> @$el.remove()

    onPorterEntitiesUpdate: (porter_entity) ->
      @updateTotals()
      @renderProducts()

    updateData: ->
      @updateName()
      @updateTotals()

    updateTotals: () ->
      day = @currentDay()
      @$el.find('.today_total').text(@model.today_weight(day))
      @$el.find('.total').text(@model.total_weight())

    updateName: ->
      @$el.find('.name').text(@model.name())
  )
)()