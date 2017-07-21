#= require collections/menu_partition_porter_collection
#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require models/entity_assigner_to_each_porter
#= require models/entity_assigner_to_all_porters
#= require models/entity_assigner_apply_to_all_same

_.namespace "App.views"
(->
  days = App.collections.MenuDayCollection
  App.views.MenuPortersDropdownView = Backbone.View.extend(
    tagName: 'div'
    className: 'porters-dropdown well well-sm'
    events:
      'click .porter': 'createPorterEntity'
      'click .each-porter': 'assignToEachPorter'
      'click .all-porters': 'assignToAllPorters'
      'click .apply-to-all': 'applyToAll'

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

    entity: (e) ->
      entityId = $(e.target).closest('.entity').data('entity-id')
      App.collections.MenuDayEntityCollection.get(entityId)

    assignToEachPorter: (e) ->
      new App.models.EntityAssignerToEachPorter(@entity(e)).assign()

    assignToAllPorters: (e) ->
      new App.models.EntityAssignerToAllPorters(@entity(e), @porters.models).assign()

    applyToAll: (e) ->
      new App.models.EntityAssignerApplyToAllSame(@entity(e)).assign()

    createPorterEntity: (e)->
      porter_id = $(e.currentTarget).find('.name').data('porter-id')
      porter_entity = new App.models.MenuPartitionPorterDayEntityModel
        partition_porter_id: porter_id
        day_entity_id: @entity(e).get('id')
      App.collections.MenuPartitionPorterDayEntityCollection.push porter_entity

  )
)()
