#= require collections/menu_day_collection
#= require collections/menu_day_entity_collection
#= require collections/menu_partition_porter_collection
#= require collections/menu_partition_porter_day_entity_collection
#= require models/menu_day_entity_model
#= require views/menu/partition/menu_porters_dropdown_view
#= require views/menu/partition/menu_partition_entity_porters_view
_.namespace "App.views"
(->
  App.views.MenuPartitionEntityView = Backbone.View.extend(
    tagName: 'div'
    className: 'entity'

    initialize: (options) ->
      @options = options
      @model = options.model
      @entities = App.collections.MenuDayEntityCollection
      @porters = App.collections.MenuPartitionPorterCollection
      @render()

    render: ->
      @$el.html($(JST["templates/food/partition/day_entity"](entity: @model, total_weight: @_totalWeight())))
      @$el.attr('id', "entity_#{@model.id}").addClass("entity-#{@model.get('entity_type')}")
      @options.renderTo.append @$el

      if @model.isProduct()
        @portersView = new App.views.MenuPartitionEntityPortersView
          renderTo: @$el.find('.entity-porters')
          entity: @model

    renderEntities: (entities) ->
      _.each(entities, ((entity) ->
        entity_view = @renderEntity entity.entity
        entity_view.renderEntities entity.children if entity.children
      ), this)

    renderEntity: (entity) ->
      new App.views.MenuPartitionEntityView
        model: entity
        renderTo: @$el.find('> .body')

    updateTotalWeight: ->
      @$el.find('.entity-total-weight').html(@_totalWeight() + I18n.t('menu.g'))

    _totalWeight: ->
      @model.get('weight') * @porters.length
  )
)()
