#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection
#= require models/menu_day_entity_model
#= require views/menu/partition/menu_porters_dropdown_view
_.namespace "App.views"
(->
  porters_dropdown_view = new App.views.MenuPortersDropdownView
    days_tabs: '#menu .nav-tabs'
  porter_entities = App.collections.MenuPartitionPorterDayEntityCollection

  App.views.MenuPartitionEntityView = Backbone.View.extend(
    tagName: 'div'
    className: 'entity'

    initialize: (options) ->
      @options = options
      @model = options.model
      @entities = App.collections.MenuDayEntityCollection
      @porters = App.collections.MenuPartitionPorterCollection
      @porter_entities = App.collections.MenuPartitionPorterDayEntityCollection
      @current_porter_entity = @_currentPorterEntity()
      @render()
      @bindEvents()

    render: ->
      @$el.html($(JST["templates/food/partition/day_entity"](entity: @model, total_weight: @_totalWeight())))
      @$el.attr('id', "entity_#{@model.id}").addClass("entity-#{@model.get('entity_type')}")
      @options.renderTo.append @$el

      @renderPorter() if @model.isProduct()

    renderEntities: (entities) ->
      _.each(entities, ((entity) ->
        entity_view = @renderEntity entity.entity
        entity_view.renderEntities entity.children if entity.children
      ), this)

    renderEntity: (entity) ->
      new App.views.MenuPartitionEntityView
        model: entity
        renderTo: @$el.find('> .body')

    bindEvents: ->
      if @model.isProduct()
        @$el.on('click', '.add-porter', $.proxy(@showPortersDropdown, this))
        @$el.on('click', '.assign-all', $.proxy(@assignAll, this))
        @$el.on('click', '.remove-porter', $.proxy(@removePorter, this))
        @porters.on 'add', $.proxy(@updateTotalWeight, this)
        @porters.on 'remove', $.proxy(@updateTotalWeight, this)
        @porter_entities.on 'add', $.proxy(@onPorterEntityAdd, this)

    renderPorter: ->
      html = $(JST["templates/food/partition/day_entity_porter"](porter: @_currentPorter()))
      @$el.find('.entity-porter').html(html)

    showPortersDropdown: (e) ->
      e.stopPropagation()

      return alert('No porters') if (@porters.length == 0)

      porters_dropdown_view.onSelect($.proxy(@createPorterEntity, this))
      porters_dropdown_view.renderTo(@$el.find('> .body'))

    createPorterEntity: (e)->
      porter_id = $(e.currentTarget).find('.name').data('porter-id')

      @current_porter_entity = new App.models.MenuPartitionPorterDayEntityModel
        partition_porter_id: porter_id
        day_entity_id: @model.get('id')
      porter_entities.push @current_porter_entity

      @current_porter_entity.on('add', @onPorterEntityAdd, this)
      @current_porter_entity.on('remove', @onPorterEntityRemove, this)
      @porters.get(porter_id).on('change:name', @onPorterNameChange, this)

      @renderPorter()

    onPorterEntityAdd: (porter_entity) ->
      if porter_entity.get('day_entity_id') == @model.get('id')
        @current_porter_entity = porter_entity
        @renderPorter()

    onPorterEntityRemove: ->
      @current_porter_entity = null
      @renderPorter()

    onPorterNameChange: ->
      @renderPorter()

    onPortersUpdate: ->

    updateTotalWeight: ->
      @$el.find('.entity-total-weight').html(@_totalWeight())

    _totalWeight: ->
      @model.get('weight') * @porters.length

    removePorter: ->
      @porter_entities.remove([@current_porter_entity])

    assignAll: ->
      porter = @_currentPorter()

      _.each(@entities.allAs(@model), (entity) ->
        return true if entity.get('id') == @model.get('id')

        porter_entity = @porter_entities.byEntity(entity)
        @porter_entities.remove porter_entity if porter_entity

        porter_entity = new App.models.MenuPartitionPorterDayEntityModel
          partition_porter_id: porter.get('id')
          day_entity_id: entity.get('id')
        porter_entities.push porter_entity

      , this)

    _currentPorterEntity: ->
      @porter_entities.byEntity @model

    _currentPorter: ->
      if @current_porter_entity then @current_porter_entity.porter() else null
  )
)()
