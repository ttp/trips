#= require collections/menu_partition_porter_collection
#= require collections/menu_day_collection

_.namespace "App.views"
(->
  days = App.collections.MenuDayCollection
  App.views.MenuPortersDropdownView = Backbone.View.extend(
    tagName: 'div'
    className: 'porters-list well well-sm'
    events:
      'click .porter': 'selectPorter'

    initialize: (options) ->
      @porters = App.collections.MenuPartitionPorterCollection
      @days_tabs = options.days_tabs
      @bindEvents()

    renderTo: (el) ->
      html = JST["templates/food/partition/porters_dropdown"](porters: @porters.models, day: @currentDay())
      @$el.html(html)
      el.append(@$el)
      @$el.show()

    bindEvents: ->
      $('body').click $.proxy(@hide, this)

    currentDay: ->
      day_id = $(@days_tabs).find('li.active').data('day_id')
      days.get(day_id)

    hide: ->
      @$el.hide()

    onSelect: (callback, scope) ->
      @selectCallback = callback
      @selectCallbackScope = scope

    selectPorter: (e) ->
      @selectCallback.call(@selectCallbackScope, e)

  )
)()
