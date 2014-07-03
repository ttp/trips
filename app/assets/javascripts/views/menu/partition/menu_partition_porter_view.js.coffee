#= require collections/menu_partition_porter_collection
#= require collections/menu_day_collection

_.namespace "App.views"
(->
  days = App.collections.MenuDayCollection
  App.views.MenuPartitionPorterView = Backbone.View.extend(
    tagName: 'div'
    className: 'porter'

    initialize: (options) ->
      @model = options.model
      @days_tabs = options.days_tabs
      @render()
      @bindEvents()

    render: ->
      @$el.html $(JST["templates/food/partition/porter"](porter: @model, day: @currentDay()))
      @options.renderTo.append @$el

    bindEvents: ->
      @model.on('change:position', @updateName, this)
      @model.on('remove', $.proxy(@onRemove, this))
      @days_tabs.on 'click', $.proxy(@onDayChange, this)

    currentDay: ->
      day_id = @days_tabs.find('li.active').data('day_id')
      days.get(day_id)

    onDayChange: -> @updateTotals()

    onRemove: -> @$el.remove()

    updateData: ->
      @updateName()
      @updateTotals()

    updateTotals: () ->
      day = @currentDay()
      @$el.find('.currenty_total').text(@model.currently_weight(day))
      @$el.find('.total').text(@model.total_weight())

    updateName: ->
      @$el.find('.name').text(@model.name())
  )
)()