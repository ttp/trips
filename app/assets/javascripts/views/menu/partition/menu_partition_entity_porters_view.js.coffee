#= require models/entity_assigner_to_porter

_.namespace "App.views"
(->
  porters_dropdown_view = new App.views.MenuPortersDropdownView
    days_tabs: '#menu .nav-tabs'

  App.views.MenuPartitionEntityPortersView = Backbone.View.extend(
    initialize: (options) ->
      @$el = options.renderTo
      @entity = options.entity
      @entities = App.collections.MenuDayEntityCollection
      @porters = App.collections.MenuPartitionPorterCollection
      @porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
      @render()
      @bindEvents()

    bindEvents: ->
      @$el.on('click', '.add-porter', $.proxy(@showPortersDropdown, this))
      @$el.on('click', '.assign-all', $.proxy(@assignAll, this))
      @$el.on('click', '.remove-porter', $.proxy(@removePorter, this))
      @porter_entities.on 'add', $.proxy(@onPorterEntityAdd, this)
      @porter_entities.on 'remove', $.proxy(@onPorterEntityRemove, this)
      @porters.on 'add', $.proxy(@onPorterAddRemove, this)
      @porters.on 'remove', $.proxy(@onPorterAddRemove, this)
      _.each @porterEntities(), (porter_entity) ->
        @bindEntityEvents(porter_entity)
      , this

    render: ->
      html = $(JST["templates/food/partition/day_entity_porter"](porter_entities: @porterEntities()))
      @$el.html(html)

    showPortersDropdown: (e) ->
      e.stopPropagation()
      return alert(I18n.t('menu.partitions.no_porters')) if (@porters.length == 0)
      porters_dropdown_view.renderTo(@$el.closest('.entity'))

    bindEntityEvents: (porter_entity) ->
      porter_entity.on('remove', @render, this)
      porter_entity.porter().on('change:name', @render, this)

    onPorterEntityAdd: (porter_entity) ->
      if porter_entity.get('day_entity_id') == @entity.get('id')
        @bindEntityEvents(porter_entity)
        @render()

    onPorterEntityRemove: (porter_entity) ->
      if porter_entity.get('day_entity_id') == @entity.get('id')
        @render()

    onPorterAddRemove: ->
      @render()

    updateTotalWeight: ->
      @$el.find('.entity-total-weight').html(@totalWeight() + I18n.t('menu.g'))

    totalWeight: ->
      @entity.get('weight') * @porters.length

    removePorter: (e) ->
      e.preventDefault()
      @porter_entities.remove @porterEntityFromEvent(e)

    porterEntityFromEvent: (e) ->
      entity_id = $(e.target).closest('.btn-group').data('entity-id')
      @porter_entities.get(entity_id)

    assignAll: (e) ->
      e.preventDefault()
      setTimeout (-> $('body').trigger('click')), 1
      porter = @porterEntityFromEvent(e).porter()
      new App.models.EntityAssignerToPorter(@entity, porter).assign()

    porterEntities: ->
      @porter_entities.byEntity @entity
  )
)()